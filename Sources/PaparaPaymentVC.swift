//
//  PaparaPaymentVC.swift
//  Papara
//
//  Created by Mehmet Salih Aslan on 31/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation

class PaparaPaymentVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
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
        webView.delegate = self
        webView.loadRequest(URLRequest(url: URL(string: paymentUrl)!))
    }
    
}

extension PaparaPaymentVC: UIWebViewDelegate {
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let url = request.url?.absoluteString {
            if url.contains(redirectUrl){
                closeButton.isEnabled = false
                let parameters = request.url!.queryItems!
                self.dismiss(animated: true) {
                    let paymentId = parameters["paymentId"]!
                    let referenceId = parameters["referenceId"]!
                    let status = parameters["status"]!.toInt
                    let amount = parameters["amount"]!.toDouble
                    self.payCompletion(PayResult.success(paymentId: paymentId, referenceId: referenceId, status: status, amount: amount))
                }
                return false
            }
            else if url.contains(errorURL) {
                self.payCompletion(PayResult.fail(error: NSError(domain: Papara.shared.domain, code: 0, userInfo: ["localizedDescription": Localization.Error.Unexpected])))
            }
        }
        return true
    }
    
}
