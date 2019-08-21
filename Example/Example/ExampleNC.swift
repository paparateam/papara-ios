//
//  ExampleNC.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 25/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import UIKit
import CoreGraphics

class ExampleNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 18)]
        navigationBar.tintColor = .white
        navigationBar.barTintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.shadowImage = UIImage()
        var bounds = self.navigationBar.bounds
        bounds.size.height += 20
        navigationBar.setBackgroundImage(createGradientImage(bounds: bounds), for: .default)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createGradientImage(bounds: CGRect) -> UIImage {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        layer.frame = bounds
        layer.colors = [UIColor.mainOrange.cgColor, UIColor.mainPurple.cgColor]
        
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
