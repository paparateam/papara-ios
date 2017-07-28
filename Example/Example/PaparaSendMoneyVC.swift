//
//  PaparaSendMoneyVC.swift
//  Example
//
//  Created by Utku Yildirim on 02/12/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import UIKit
import Papara

class PaparaSendMoneyVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var walletTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    public enum SendMoneyType {
        case paparaNumber
        case email
        case mobile
    }
    
    var sendMoneyType: SendMoneyType = .paparaNumber
    
    @IBAction func sendButton(_ sender: AnyObject) {
        
        let wallet = walletTextField.text!.trimmingCharacters(in: .whitespaces)
        let amountString = amountTextField.text!.trimmingCharacters(in: .whitespaces)
        
        var to: SendMoneyType?;
        switch sendMoneyType {
        case .paparaNumber:
            if wallet.isEmpty {
                showAlertDialog("Hata", message: "Lütfen papara numarası giriniz.")
                return
            }
            let paparaNumber = Int(wallet)
            
            if paparaNumber == nil {
                showAlertDialog("Hata", message: "Geçersiz Papara Numarası girdiniz.")
                return
            }
        case .email:
            if wallet.isEmpty {
                showAlertDialog("Hata", message: "Lütfen e-posta adresi giriniz.")
                return
            }
        case .mobile:
            if wallet.isEmpty {
                showAlertDialog("Hata", message: "Lütfen telefon numarası giriniz.")
                return
            }
        }
        
        if amountString.isEmpty {
            showAlertDialog("Hata", message: "Lütfen tutar giriniz.")
            return
        }
        
        let amount = Double(amountString.replacingOccurrences(of: ",", with: "."))
        
        if amount == nil {
            showAlertDialog("Hata", message: "Geçersiz tutar girdiniz.")
            return
        }
        
        if description.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen açıklama giriniz.")
            return
        }
        
        switch sendMoneyType {
        case .paparaNumber:
            Papara.sendMoney(self, to: .paparaNumber(Int64(wallet)!), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog("Success", message: "Success")
                case .fail(let error):
                    self.showAlertDialog("Fail", message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog("Cancel", message: "Cancel")
                }
            }
        case .mobile:
            Papara.sendMoney(self, to: .mobile(wallet), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog("Success", message: "Success")
                case .fail(let error):
                    self.showAlertDialog("Fail", message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog("Cancel", message: "Cancel")
                }
            }
        case .email:
            Papara.sendMoney(self, to: .email(wallet), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog("Success", message: "Success")
                case .fail(let error):
                    self.showAlertDialog("Fail", message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog("Cancel", message: "Cancel")
                }
            }
        }
    }
    
    @IBAction func segmentControlDidValueChange(_ sender: Any) {
        self.view.endEditing(true)
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            walletTitleLabel.text = "Papara Numarası"
            walletTextField.text = "1441345047"
            walletTextField.placeholder = "Örn: 1441345047"
            walletTextField.keyboardType = .numberPad
            sendMoneyType = .paparaNumber
        case 1:
            walletTitleLabel.text = "E-posta Adresi"
            walletTextField.text = "salih.aslan@mobillium.com"
            walletTextField.placeholder = "Örn: salih.aslan@mobillium.com"
            walletTextField.keyboardType = .emailAddress
            sendMoneyType = .email
        case 2:
            walletTitleLabel.text = "Telefon Numarası"
            walletTextField.text = "+905535750045"
            walletTextField.placeholder = "Örn: +905535750045"
            walletTextField.keyboardType = .phonePad
            sendMoneyType = .mobile
        default:
            walletTitleLabel.text = "Papara Numarası"
            walletTextField.text = "1441345047"
            walletTextField.placeholder = "Örn: 1441345047"
            walletTextField.keyboardType = .numberPad
            sendMoneyType = .paparaNumber
        }
    }
    
    
    
    func showAlertDialog(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "TAMAM", style: UIAlertActionStyle.cancel) { (_) in }
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.registerKeyboardNotifications()
        
        walletTextField.text = "1441345047"
        amountTextField.text = "1.00"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Keyboard Management
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.scrollIndicatorInsets.bottom = keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    
}

