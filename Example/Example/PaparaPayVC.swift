//
//  PaparaPayVC.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 28/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import UIKit
import Papara

class PaparaPayVC: UIViewController {
        
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    
    @IBAction func payButtonClick(_ sender: Any) {
        
        let amountString = amountTextField.text!.trimmingCharacters(in: .whitespaces)
        
        if amountString.isEmpty {
            showAlertDialog(Resources.error, message: Resources.amountAlert)
            return
        }
        
        let amount = Double(amountString.replacingOccurrences(of: ",", with: "."))
        
        if amount == nil {
            showAlertDialog(Resources.error, message: Resources.invalidAmountAlert)
            return
        }
        
        let pay = Pay(amount: amount!)
        
        let alertController = UIAlertController(title: Resources.paymentGoingOn, message: nil, preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion:  {
            WebService.request(request: pay, success: { (payment: Payment) in
                alertController.dismiss(animated: true, completion: { 
                    self.payWithPapara(payment)
                })
            }) { (error) in
                alertController.dismiss(animated: true, completion: { 
                    self.showAlertDialog(Resources.error, message: error.message ?? "")
                })
            }
        })
        
    }
    
    func payWithPapara(_ payment: Payment) {
        guard let url = payment.paymentUrl,
              let redirectUrl = payment.returningRedirectUrl else {
            showAlertDialog(Resources.error, message: Resources.dontLeaveEmpty)
            return
        }
        
        Papara.pay(self, paymentId: payment.id ?? "", paymentUrl: url, redirectUrl: redirectUrl) { (result) in
            switch result {
            case .success:
                self.showAlertDialog(Resources.success, message: Resources.success)
            case .fail(let error):
                self.showAlertDialog(Resources.error, message: error.localizedDescription)
            case .cancel:
                self.showAlertDialog(Resources.cancel, message: Resources.cancel)
            }
        }
    }
    
    func showAlertDialog(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Resources.ok, style: .cancel) { (_) in }
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
