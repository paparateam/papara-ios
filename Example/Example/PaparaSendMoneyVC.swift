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
        
        switch sendMoneyType {
        case .paparaNumber:
            if wallet.isEmpty {
                showAlertDialog(Resources.error, message: Resources.paparaNoAlert)
                return
            }
            let paparaNumber = Int(wallet)
            
            if paparaNumber == nil {
                showAlertDialog(Resources.error, message: Resources.paparaNoAlert)
                return
            }
        case .email:
            if wallet.isEmpty {
                showAlertDialog(Resources.error, message: Resources.emailAlert)
                return
            }
        case .mobile:
            if wallet.isEmpty {
                showAlertDialog(Resources.error, message: Resources.phoneAlert)
                return
            }
        }
        
        if amountString.isEmpty {
            showAlertDialog(Resources.error, message: Resources.amountAlert)
            return
        }
        
        let amount = Double(amountString.replacingOccurrences(of: ",", with: "."))
        
        if amount == nil {
            showAlertDialog(Resources.error, message: Resources.invalidAmountAlert)
            return
        }
        
        if description.count == 0 {
            showAlertDialog(Resources.error, message: Resources.descriptionAlert)
            return
        }
        
        switch sendMoneyType {
        case .paparaNumber:
            Papara.sendMoney(self, to: .paparaNumber(Int64(wallet)!), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog(Resources.success, message: Resources.success)
                case .fail(let error):
                    self.showAlertDialog(Resources.fail, message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog(Resources.cancel, message: Resources.cancel)
                }
            }
        case .mobile:
            Papara.sendMoney(self, to: .mobile(wallet), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog(Resources.success, message: Resources.success)
                case .fail(let error):
                    self.showAlertDialog(Resources.fail, message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog(Resources.cancel, message: Resources.cancel)
                }
            }
        case .email:
            Papara.sendMoney(self, to: .email(wallet), amount: amount!) { (result) in
                switch result {
                case .success:
                    self.showAlertDialog(Resources.success, message: Resources.success)
                case .fail(let error):
                    self.showAlertDialog(Resources.fail, message: error.localizedDescription)
                case .cancel:
                    self.showAlertDialog(Resources.cancel, message: Resources.cancel)
                }
            }
        }
    }
    
    @IBAction func segmentControlDidValueChange(_ sender: Any) {
        self.view.endEditing(true)
        walletTextField.text = nil
        switch (sender as! UISegmentedControl).selectedSegmentIndex {
        case 0:
            walletTitleLabel.text = Resources.paparaNo
            walletTextField.placeholder = "\(Resources.exp) 0123456789"
            walletTextField.keyboardType = .numberPad
            sendMoneyType = .paparaNumber
        case 1:
            walletTitleLabel.text = Resources.mailAddress
            walletTextField.placeholder = "\(Resources.exp) mail@gmail.com"
            walletTextField.keyboardType = .emailAddress
            sendMoneyType = .email
        case 2:
            walletTitleLabel.text = Resources.phoneNumber
            walletTextField.placeholder = "\(Resources.exp) +905311112233"
            walletTextField.keyboardType = .phonePad
            sendMoneyType = .mobile
        default: break
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
        // Do any additional setup after loading the view, typically from a nib.
        self.registerKeyboardNotifications()
        
        amountTextField.text = "1.00"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Keyboard Management
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.scrollIndicatorInsets.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    
}

