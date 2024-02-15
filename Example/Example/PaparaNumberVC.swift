//
//  PaparaNumberVC.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 28/07/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import Foundation
import UIKit
import Papara

class PaparaNumberVC: UIViewController {
    
    @IBOutlet weak var paparaNoTextField: UITextField!
    
    @IBAction func paparaNumberButtonClick(_ sender: Any) {
        Papara.getPaparaNumber(self) { (result) in
            switch result {
            case .success(let paparaNumber):
                self.paparaNoTextField.text = String(paparaNumber)
                self.showAlertDialog(Resources.success, message: String(paparaNumber))
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
        paparaNoTextField.placeholder = Resources.paparaNo
    }
    
}
