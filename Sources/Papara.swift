//
//  Papara.swift
//  Papara
//
//  Created by Utku Yildirim on 11/11/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import Foundation

public class Papara {

    static let shared = Papara()
    
    private static let appStoreUrl = NSURL(string: "itms-apps://itunes.apple.com/app/papara-cuzdan/id1146507477")!
    private static var paparaSchema: String {
        get {
            return Papara.shared.sandbox ?  "papara-sandbox" : "papara"
        }
    }
    
    var application: UIApplication!
    var appId: String!
    var sandbox = false
    
    private var sendMoneyCompletion: ((result: Result, code: Int, message: String) -> Void)!
    
    // MARK: - SDK
    
    public class func sendMoney(presentViewController: UIViewController, wallet: String, amount: Double, description: String, completion: (result: Result, code: Int, message: String) -> Void) {
        
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
    
    public class func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) {
        
        Papara.shared.application = application
        
        if let PaparaAppID = NSBundle.mainBundle().objectForInfoDictionaryKey("PaparaAppID") as? String {
            Papara.shared.appId = PaparaAppID
        }
        else {
            fatalError("PaparaAppId should be set.")
        }
        
        if let PaparaSandbox = NSBundle.mainBundle().objectForInfoDictionaryKey("PaparaSandbox") as? Bool {
            Papara.shared.sandbox = PaparaSandbox
        }
        else {
            // Nothing sandbox optional
        }
        
        if let schemas = NSBundle.mainBundle().objectForInfoDictionaryKey("LSApplicationQueriesSchemes") as? [String] {
            if schemas.indexOf(paparaSchema) == nil {
                fatalError(paparaSchema + " should be added to schemas.")
            }
        }
    }
    
    public class func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return self.application(application, openURL: url, options: [:])
    }
    
    public class func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        if url.host == DeepLinkHostType.sendMoney.rawValue {
            if let path = DeepLinkPathType(rawValue: url.path!) {
                
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
                
                Papara.shared.sendMoneyCompletion(result: result, code: code, message: message)
                
                return true
            }
        }
        return false
    }
    
    // MARK: - Internal
    
    class func bundle() -> NSBundle {
        let bundle = NSBundle(forClass: self)
        if let bundleUrl = bundle.URLForResource("Papara", withExtension: "bundle"), let podBundle = NSBundle(URL: bundleUrl) {
            return podBundle
        }
        return bundle
    }
    
    // MARK: - Private
    
    private class func isInitialized() -> Bool {
        return Papara.shared.application != nil && Papara.shared.appId != nil
    }
    
    private class func openPapara(presentViewController: UIViewController, path: DeepLinkHostType, params: [String: String]) {
        
        if !Papara.shared.application.canOpenURL(NSURL(string: paparaSchema + "://")!) {
            let alertController = UIAlertController(title: Localization.AppNotFound.Title, message: Localization.AppNotFound.Message, preferredStyle: .Alert)
            
            let acceptAction = UIAlertAction(title: Localization.AppNotFound.Install, style: UIAlertActionStyle.Default) { (cancelAction) in
                UIApplication.sharedApplication().openURL(appStoreUrl)
            }
            
            let cancelAction = UIAlertAction(title: Localization.AppNotFound.Cancel, style: UIAlertActionStyle.Default) { (cancelAction) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(acceptAction)
            
            presentViewController.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        Papara.shared.application.openURL(createURL(path.rawValue, params: params))
    }
    
    private class func createURL(path: String, params: [String: String]) -> NSURL {
        let scheme = paparaSchema + "://"
        let urlComp = NSURLComponents(string: scheme+path)!
        var queryItems = [NSURLQueryItem]()
        
        var parameters = params
        parameters["appId"] = Papara.shared.appId
        parameters["displayName"] = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
        parameters["appPackageName"] = NSBundle.mainBundle().bundleIdentifier
        parameters["appVersion"] = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        parameters["appBuild"] = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        parameters["sdkVersion"] = NSBundle(forClass: self).objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
        parameters["osVersion"] = UIDevice.currentDevice().systemVersion
        parameters["brand"] = "Apple"
        parameters["model"] = UIDevice.currentDevice().modelName
        parameters["language"] = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as? String
        
        for (key, value) in parameters {
            queryItems.append(NSURLQueryItem(name: key, value: value))
        }
    
        urlComp.queryItems = queryItems
        
        return urlComp.URL!
    }
}
