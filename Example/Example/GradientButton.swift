//
//  GradientButton.swift
//  Example
//
//  Created by Mehmet Salih Aslan on 25/08/2017.
//  Copyright © 2017 Mobillium. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0
    @IBInspectable var startColor: UIColor = .mainOrange
    @IBInspectable var endColor: UIColor = .mainPurple
    @IBInspectable var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.0)
    @IBInspectable var customFont: UIFont?
    
    private var gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: super.intrinsicContentSize.width
                + contentEdgeInsets.left
                + contentEdgeInsets.right
                + titleEdgeInsets.left
                + titleEdgeInsets.right
                + imageEdgeInsets.left
                + imageEdgeInsets.right,
                          height: 46)
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        awakeFromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = cornerRadius
        if cornerRadius > 0 {
            layer.masksToBounds = true
        } else {
            layer.masksToBounds = false
        }
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = .clear
        if customFont != nil {
            titleLabel?.font = customFont
        } else {
            titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }
    
}
