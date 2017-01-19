//
//  ViewController.swift
//  Example
//
//  Created by Utku Yildirim on 02/12/2016.
//  Copyright © 2016 Mobillium. All rights reserved.
//

import UIKit
import Papara

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var walletTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBAction func sendButton(_ sender: AnyObject) {
        
        let wallet = walletTextField.text?.trimmingCharacters(in: .whitespaces)
        let amountString = amountTextField.text?.trimmingCharacters(in: .whitespaces)
        let description = descriptionTextView.text.trimmingCharacters(in: .whitespaces)
    
        if wallet?.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen cüzdan numarası giriniz.")
            return
        }
        if amountString?.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen tutar giriniz.")
            return
        }
        
        let amount = Double(amountString!.replacingOccurrences(of: ",", with: "."))
        
        if amount == nil {
            showAlertDialog("Hata", message: "Geçersiz tutar girdiniz.")
            return
        }
        if description.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen açıklama giriniz.")
            return
        }
        
        Papara.sendMoney(self, wallet!, amount!, description) { (result, code, message) in
            switch result {
            case .success:
                self.showAlertDialog("Başarılı", message: message);
            case .fail:
                self.showAlertDialog("Hata", message: message);
            case .cancel:
                self.showAlertDialog("İptal", message: message);
            }
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
        
        walletTextField.text = "ML9433183768"
        amountTextField.text = "1.00"
        descriptionTextView.text = "Test"
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

