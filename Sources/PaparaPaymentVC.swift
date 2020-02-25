//
//  PaparaPaymentVC.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 31/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation
import WebKit

class PaparaPaymentVC: UIViewController {
    
    weak var webView: WKWebView!
    weak var closeButton: UIBarButtonItem!
    
    var errorURL: String {
        return Papara.shared.sandbox ? "https://test-master.papara.com/error" : "https://www.papara.com/error"
    }
    
    var paymentUrl: String!
    var redirectUrl: String!
    var payCompletion: Papara.PayCompletion!
    
    @IBAction func closeButtonClick(_ sender: Any) {
        self.dismiss(animated: true) { 
            self.payCompletion(PayResult.cancel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        edgesForExtendedLayout = .all
        view.backgroundColor = .white
        
        navigationController?.presentationController?.delegate = self
        
        let webView = WKWebView(frame: view.frame)
        webView.navigationDelegate = self
        view.addSubview(webView)
        self.webView = webView
        
        var closeButtonStyle: UIBarButtonItem.SystemItem
        if #available(iOS 13.0, *) {
            closeButtonStyle = .close
        } else {
            closeButtonStyle = .cancel
        }
        let closeButton = UIBarButtonItem(barButtonSystemItem: closeButtonStyle, target: self, action: #selector(closeButtonClick(_:)))
        navigationItem.rightBarButtonItem = closeButton
        
        guard
            let url = URL(string: paymentUrl)
        else {
            self.payCompletion(PayResult.fail(error: NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Unexpected])))
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var webViewFrame = view.frame
        if #available(iOS 11.0, *) {
            webViewFrame = view.frame.inset(by: view.safeAreaInsets)
        }
        webView.frame = webViewFrame
    }
}

extension PaparaPaymentVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
        
        if let successUrl = self.redirectUrl, url.contains(successUrl) {
            decisionHandler(.cancel)
            guard
                let parameters = navigationAction.request.url?.queryItems
            else {
                decisionHandler(.cancel)
                self.payCompletion(PayResult.fail(error: NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Unexpected])))
                return
            }
            
            self.dismiss(animated: true) {
                let paymentId = parameters["paymentId"]!
                let referenceId = parameters["referenceId"]!
                let status = parameters["status"]!.toInt
                let amount = parameters["amount"]!.toDouble
                self.payCompletion(PayResult.success(paymentId: paymentId, referenceId: referenceId, status: status, amount: amount))
            }
        } else if url.contains(errorURL) {
            decisionHandler(.cancel)
            self.payCompletion(PayResult.fail(error: NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Unexpected])))
        } else {
            decisionHandler(.allow)
        }
    }
}

extension PaparaPaymentVC: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.dismiss(animated: true) {
            self.payCompletion(PayResult.cancel)
        }
    }
    
}
