//
//  TopicsCardDesign.swift
//  Socrates
//
//  Created by Harsh Patel on 5/9/21.
//  Copyright © 2021 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class TopicsCardDesign: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 7
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    
    @IBInspectable var shadowOffSetWidth: Int = 0
    @IBInspectable var shadowOffSetHeight: Int = 0
    
    @IBInspectable var shadowOpacity: Float = 0.2
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffSetWidth, height: shadowOffSetHeight)
        
        let shadowPath = UIBezierPath(roundedRect: bounds,cornerRadius: cornerRadius)
        
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = shadowOpacity
    }
    
}
