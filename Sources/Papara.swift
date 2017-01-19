//
//  Papara.swift
//  Papara
//
//  Created by Utku Yildirim on 11/11/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import Foundation

public class Papara {
    
    public typealias SendMoneyCompletion = ((_ result: Result, _ code: Int, _ message: String) -> Void)
    
    static let shared = Papara()
    
    private static let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/papara-cuzdan/id1146507477")!
    private static var paparaSchema: String {
        get {
            return Papara.shared.sandbox ? "papara-sandbox" : "papara"
        }
    }
    
    private var application: UIApplication!
    private var appId: String!
    private var sandbox = false
    
    private var sendMoneyCompletion: SendMoneyCompletion!
    
    // MARK: - SDK
    public class func sendMoney(_ presentViewController: UIViewController, _ wallet: String, _ amount: Double, _ description: String, _ completion: @escaping SendMoneyCompletion) {
        
        Papara.shared.sendMoneyCompletion = completion
        
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        var parameters = [String: String]()
        parameters["toWallet"] = wallet
        parameters["amount"] = String(amount)
        parameters["description"] = description
        
        openPapara(presentViewController, path: DeepLinkHostType.sendMoney, params: parameters)
    }
    
    // MARK: - AppDelegate
    
    public class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Papara.shared.application = application
        
        if let PaparaAppID = Bundle.main.object(forInfoDictionaryKey: "PaparaAppID") as? String {
            Papara.shared.appId = PaparaAppID
        }
        else {
            fatalError("PaparaAppId should be set.")
        }
        
        if let PaparaSandbox = Bundle.main.object(forInfoDictionaryKey: "PaparaSandbox") as? Bool {
            Papara.shared.sandbox = PaparaSandbox
        }
        else {
            // Nothing sandbox optional
        }
        
        if let schemas = Bundle.main.object(forInfoDictionaryKey: "LSApplicationQueriesSchemes") as? [String] {
            if schemas.index(of: paparaSchema) == nil {
                fatalError(paparaSchema + " should be added to schemas.")
            }
        }
    }
    
    public class func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return self.application(application, open: url, options: [:])
    }
    
    public class func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        if url.host == DeepLinkHostType.sendMoney.rawValue {
            if let path = DeepLinkPathType(rawValue: url.path) {
                
                var result: Result!
                switch path {
                case .success:
                    result = .success
                case .fail:
                    result = .fail
                case .cancel:
                    result = .cancel
                }
                
                let params = url.queryItems;
                let code = params!["code"]!.toInt()
                let message = params!["message"]!
                
                Papara.shared.sendMoneyCompletion(result, code, message)
                
                return true
            }
        }
        return false
    }
    
    // MARK: - Internal
    
    class func bundle() -> Bundle {
        let bundle = Bundle(for: self)
        if let bundleUrl = bundle.url(forResource: "Papara", withExtension: "bundle"), let podBundle = Bundle(url: bundleUrl) {
            return podBundle
        }
        return bundle
    }
    
    // MARK: - Private
    
    private class func isInitialized() -> Bool {
        return Papara.shared.application != nil && Papara.shared.appId != nil
    }
    
    private class func openPapara(_ presentViewController: UIViewController, path: DeepLinkHostType, params: [String: String]) {
        
        if !Papara.shared.application.canOpenURL(URL(string: paparaSchema + "://")!) {
            let alertController = UIAlertController(title: Localization.AppNotFound.Title, message: Localization.AppNotFound.Message, preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: Localization.AppNotFound.Install, style: UIAlertActionStyle.default) { (cancelAction) in
                UIApplication.shared.openURL(appStoreUrl)
            }
            
            let cancelAction = UIAlertAction(title: Localization.AppNotFound.Cancel, style: UIAlertActionStyle.default) { (cancelAction) in
                alertController.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(acceptAction)
            
            presentViewController.present(alertController, animated: true, completion: nil)
            return
        }
        
        Papara.shared.application.openURL(createURL(path.rawValue, params: params))
    }
    
    
    private class func createURL(_ path: String, params: [String: String]) -> URL {
        let scheme = paparaSchema + "://"
        var urlComp = URLComponents(string: scheme+path)!
        var queryItems = [URLQueryItem]()
        
        var parameters = params
        parameters["appId"] = Papara.shared.appId
        parameters["displayName"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        parameters["appPackageName"] = Bundle.main.bundleIdentifier
        parameters["appVersion"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        parameters["appBuild"] = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        parameters["sdkVersion"] = Bundle(for: self).object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        parameters["osVersion"] = UIDevice.current.systemVersion
        parameters["brand"] = "Apple"
        parameters["model"] = UIDevice.current.modelName
        parameters["language"] = Locale.current.languageCode
        
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComp.queryItems = queryItems
        
        return urlComp.url!
    }
    
}
