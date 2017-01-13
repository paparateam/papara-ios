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
    
    private static let appStoreMessage = "Papara ile para gönderebilmek için Papara uygulamasını yüklemeniz gerekmetedir."
    private static let appStoreUrl = NSURL(string: "itms-apps://itunes.apple.com/app/papara-cuzdan/id1146507477")!
    private static var paparaSchema: String {
        get {
            return Papara.shared.sandbox ?  "papara-sandbox" : "papara"
        }
    }
    
    var application: UIApplication!
    var appId: String!
    var sandbox = false
    
    private var sendMoneyCompletion: ((result: PaparaResult) -> Void)!
    
    public class func sendMoney(presentViewController: UIViewController, wallet: String, amount: Double, description: String, completion: (result: PaparaResult) -> Void) {
        
        Papara.shared.sendMoneyCompletion = completion
        
        if !isInitialized() {
            fatalError("Papara should be initialized.")
        }
        
        var parameters = [String: String]()
        parameters["toWallet"] = wallet
        parameters["amount"] = String(amount)
        parameters["description"] = description
        
        openPapara(presentViewController, path: "sendMoney", params: parameters)
    }
    
    private class func openPapara(presentViewController: UIViewController, path: String, params: [String: String]) {
        
        if !Papara.shared.application.canOpenURL(NSURL(string: paparaSchema + "://")!) {
            let alertController = UIAlertController(title: "Papara!", message: appStoreMessage, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Hayır", style: UIAlertActionStyle.Default) { (cancelAction) in
                alertController.dismissViewControllerAnimated(true, completion: nil)
            }
            
            let acceptAction = UIAlertAction(title: "Yükle", style: UIAlertActionStyle.Default) { (cancelAction) in
                UIApplication.sharedApplication().openURL(appStoreUrl)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(acceptAction)
            
            presentViewController.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        Papara.shared.application.openURL(createURL(path, params: params))
    }

    
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
                switch path {
                case .success:
                    Papara.shared.sendMoneyCompletion(result: .success)
                case .fail:
                    Papara.shared.sendMoneyCompletion(result: .fail)
                case .cancel:
                    Papara.shared.sendMoneyCompletion(result: .cancel)
                }
                return true
            }
        }
        return false
    }
    
    private class func isInitialized() -> Bool {
        return Papara.shared.application != nil && Papara.shared.appId != nil
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
        
        for (key, value) in parameters {
            queryItems.append(NSURLQueryItem(name: key, value: value))
            print("\(key): \(value)")
        }
    
        urlComp.queryItems = queryItems
        
        return urlComp.URL!
    }
}
