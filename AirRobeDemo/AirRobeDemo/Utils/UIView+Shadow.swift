//
//  UIView+Shadow.swift
//  AirRobeDemo
//
//  Created by King on 4/21/22.
//

import UIKit

extension UIView {
    func addShadow(_ color: CGColor? = nil){
        if color == nil {
            self.layer.shadowColor = UIColor.black.cgColor
        } else {
            self.layer.shadowColor = color!
        }
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = .zero
    }
}
