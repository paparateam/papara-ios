//
//  GradientView.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 25/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var startColor: UIColor = .mainOrange
    @IBInspectable var endColor: UIColor = .mainPurple
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)
    
    private var gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        backgroundColor = .clear
    }
    
}
