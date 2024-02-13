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
            showAlertDialog("Hata", message: "Lütfen tutar giriniz.")
            return
        }
        
        let amount = Double(amountString.replacingOccurrences(of: ",", with: "."))
        
        if amount == nil {
            showAlertDialog("Hata", message: "Geçersiz tutar girdiniz.")
            return
        }
        
        let pay = Pay(amount: amount!)
        
        let alertController = UIAlertController(title: "Ödeme oluşturuluyor...", message: nil, preferredStyle: .alert)
        
        self.present(alertController, animated: true, completion:  {
            WebService.request(request: pay, success: { (payment: Payment) in
                alertController.dismiss(animated: true, completion: { 
                    self.payWithPapara(payment)
                })
            }) { (error) in
                alertController.dismiss(animated: true, completion: { 
                    self.showAlertDialog("Error", message: error.message ?? "")
                })
            }
        })
        
    }
    
    func payWithPapara(_ payment: Payment) {
        guard let id = payment.id,
              let url = payment.paymentUrl,
              let redirectUrl = payment.redirectUrl else {
            showAlertDialog("Error", message: "Some of required data can be null!")
            return
        }
        
        Papara.pay(self, paymentId: id, paymentUrl: url, redirectUrl: redirectUrl) { (result) in
            switch result {
            case .success:
                self.showAlertDialog("Success", message: "Success")
            case .fail(let error):
                self.showAlertDialog("Error", message: error.localizedDescription)
            case .cancel:
                self.showAlertDialog("Cancel", message: "Cancel")
            }
        }
    }
    
    func showAlertDialog(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "TAMAM", style: .cancel) { (_) in }
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
