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
    
    @IBAction func sendButton(sender: AnyObject) {
        
        let wallet = walletTextField.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        let amountString = amountTextField.text?.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        let description = descriptionTextView.text.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
    
        if wallet?.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen cüzdan numarası giriniz.")
            return
        }
        if amountString?.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen tutar giriniz.")
            return
        }
        
        let amount = Double(amountString!.stringByReplacingOccurrencesOfString(",", withString: "."))
        
        if amount == nil {
            showAlertDialog("Hata", message: "Geçersiz tutar girdiniz.")
            return
        }
        if description.characters.count == 0 {
            showAlertDialog("Hata", message: "Lütfen açıklama giriniz.")
            return
        }
        
        Papara.sendMoney(self, wallet: wallet!, amount: amount!, description: description) { (result, code, message) in
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
    
    func showAlertDialog(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "TAMAM", style: UIAlertActionStyle.Cancel) { (_) in }
        alertController.addAction(alertAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.scrollView.contentInset.bottom = keyboardSize.height
            self.scrollView.scrollIndicatorInsets.bottom = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.contentInset.bottom = 0
        self.scrollView.scrollIndicatorInsets.bottom = 0
    }
    
    
}

