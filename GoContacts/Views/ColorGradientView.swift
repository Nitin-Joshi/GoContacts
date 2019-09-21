//
//  ColorGradientView.swift
//  GoContacts
//
//  Created by Nitin Joshi on 21/09/19.
//  Copyright © 2019 Nitin Joshi. All rights reserved.
//

import UIKit

class ColorGradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        
        gradientLayer.colors = [UIColor.white.cgColor, Constants.Colors.GradientMainColorWithReducedAlpha.cgColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    }
}
