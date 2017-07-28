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
    
    @IBOutlet weak var paparaNumberLabel: UILabel!
    
    @IBAction func paparaNumberButtonClick(_ sender: Any) {
        Papara.getPaparaNumber(self) { (result) in
            switch result {
            case .success(let paparaNumber):
                self.paparaNumberLabel.text = String(paparaNumber)
                self.showAlertDialog("Success", message: String(paparaNumber))
            case .fail(let error):
                self.showAlertDialog("Error", message: error.localizedDescription)
            case .cancel:
                self.showAlertDialog("Cancel", message: "Cancel")
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
    }
    
}
