//
//  Papara.swift
//  Papara
//
//  Created by Utku Yildirim on 11/11/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import Foundation

public class Papara {
    
    typealias PayCompletion = ((_ result: PayResult) -> Void)
    typealias SendMoneyCompletion = ((_ result: SendMoneyResult) -> Void)
    typealias PaparaNumberCompletion = ((_ result: PaparaNumberResult) -> Void)
    
    static let shared = Papara()
    
    fileprivate static let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/papara-cuzdan/id1146507477")!
    fileprivate static var paparaSchema: String {
        get {
            return Papara.shared.sandbox ? "papara-sandbox" : "papara"
        }
    }
    
    public var domain: String {
        get {
            return Papara.shared.sandbox ? "com.mobillium.papara-sandbox" : "com.mobillium.papara"
        }
    }
    
    fileprivate var application: UIApplication!
    fileprivate var appId: String!
    var sandbox = false
    
    fileprivate var payCompletion: PayCompletion!
    fileprivate var sendMoneyCompletion: SendMoneyCompletion!
    fileprivate var paparaNumberCompletion: PaparaNumberCompletion!
    
    // MARK: - SDKGetPaparaNumber
    public class func getPaparaNumber(_ presentViewController: UIViewController, completion: @escaping ((_ result: PaparaNumberResult) -> Void)) {
        
        Papara.shared.paparaNumberCompletion = completion
        
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        openPapara(presentViewController, host: .paparaNumber, params: [ : ])
    }
    
    // MARK: - SDKSendMoney
    public class func sendMoney(_ presentViewController: UIViewController, to: SendMoneyType, amount: Double, completion: @escaping ((_ result: SendMoneyResult) -> Void)) {
        
        Papara.shared.sendMoneyCompletion = completion
        
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        switch to.validate() {
        case .valid(var parameters):
            parameters["amount"] = amount.toString
            openPapara(presentViewController, host: DeepLinkHostType.sendMoney, params: parameters)
        case .error(let error):
            var result: SendMoneyResult!
            result = .fail(error: error)
            Papara.shared.sendMoneyCompletion(result)
        }
        
    }
    
    // MARK: - SDKPay
    public class func pay(_ presentViewController: UIViewController, paymentId: String, paymentUrl: String, redirectUrl: String,  completion: @escaping ((_ result: PayResult) -> Void)) {
        
        Papara.shared.payCompletion = completion
        
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        openPapara(presentViewController, host: DeepLinkHostType.pay, params: ["paymentId": paymentId, "paymentUrl": paymentUrl, "redirectUrl": redirectUrl])
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
    fileprivate class func isInitialized() -> Bool {
        return Papara.shared.application != nil && Papara.shared.appId != nil
    }
    
    private class func openPapara(_ presentViewController: UIViewController, host: DeepLinkHostType, params: [String: String]) {
        
        if !Papara.shared.application.canOpenURL(URL(string: paparaSchema + "://")!) {
            
            var message = Localization.AppNotFound.Message.PaparaNumber
            var cancelTitle = Localization.AppNotFound.Cancel
            
            switch host {
            case .paparaNumber:
                message = Localization.AppNotFound.Message.PaparaNumber
            case .sendMoney:
                message = Localization.AppNotFound.Message.SendMoney
            case .pay:
                cancelTitle = Localization.AppNotFound.Continue
                message = Localization.AppNotFound.Message.Pay
            }
            let alertController = UIAlertController(title: Localization.AppNotFound.Title, message: message, preferredStyle: .alert)
            
            let acceptAction = UIAlertAction(title: Localization.AppNotFound.Install, style: UIAlertActionStyle.default) { (cancelAction) in
                UIApplication.shared.openURL(appStoreUrl)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: UIAlertActionStyle.default) { (cancelAction) in
                if host == .pay {
                    let storyboard = UIStoryboard(name: "Papara", bundle: bundle())
                    let navigationController = storyboard.instantiateViewController(withIdentifier: "PaparaNC") as! UINavigationController
                    let viewController = navigationController.topViewController as! PaparaPaymentVC
                    viewController.paymentUrl = params["paymentUrl"]
                    viewController.redirectUrl = params["redirectUrl"]
                    viewController.payCompletion = Papara.shared.payCompletion
                    presentViewController.present(navigationController, animated: true, completion: nil)
                }else {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(acceptAction)
            
            presentViewController.present(alertController, animated: true, completion: nil)
            
        } else {
            Papara.shared.application.openURL(createURL(host.rawValue, params: params))
        }
    }
    
    
    private class func createURL(_ host: String, params: [String: String]) -> URL {
        let scheme = paparaSchema + "://"
        var urlComp = URLComponents(string: scheme+host)!
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

extension Papara {
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
                
                var result: SendMoneyResult!
                switch path {
                case .success:
                    result = .success
                case .fail:
                    let params = url.queryItems
                    let code = params!["code"]!.toInt
                    let error = NSError(domain: Papara.shared.domain, code: code, userInfo: params)
                    result = .fail(error: error)
                case .cancel:
                    result = .cancel
                }
                
                Papara.shared.sendMoneyCompletion(result)
                
                return true
            }
        }
        
        if url.host == DeepLinkHostType.paparaNumber.rawValue {
            if let path = DeepLinkPathType(rawValue: url.path) {
                
                var result: PaparaNumberResult!
                switch path {
                case .success:
                    let params = url.queryItems
                    let paparaNumber = params!["paparaNumber"]!.toInt64
                    result = .success(paparaNumber: paparaNumber)
                case .fail:
                    let params = url.queryItems
                    let code = params!["code"]!.toInt
                    let error = NSError(domain: Papara.shared.domain, code: code, userInfo: params)
                    result = .fail(error: error)
                case .cancel:
                    result = .cancel
                }
                
                Papara.shared.paparaNumberCompletion(result)
                
                return true
            }
        }
        
        if url.host == DeepLinkHostType.pay.rawValue {
            if let path = DeepLinkPathType(rawValue: url.path) {
                
                var result: PayResult!
                switch path {
                case .success:
                    let params = url.queryItems
                    let paymentId = params!["paymentId"]!
                    let referenceId = params!["referenceId"]!
                    let status = params!["status"]!.toInt
                    let amount = params!["amount"]!.toDouble
                    result = .success(paymentId: paymentId, referenceId: referenceId, status: status, amount: amount)
                case .fail:
                    let params = url.queryItems
                    let code = params!["code"]!.toInt
                    let error = NSError(domain: Papara.shared.domain, code: code, userInfo: params)
                    result = .fail(error: error)
                case .cancel:
                    result = .cancel
                }
                
                Papara.shared.payCompletion(result)
                
                return true
            }
        }
        
        return false
    }
    
}
