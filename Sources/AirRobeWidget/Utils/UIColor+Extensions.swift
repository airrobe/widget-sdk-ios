//
//  File.swift
//  
//
//  Created by King on 12/3/21.
//

#if canImport(UIKit)
import UIKit

extension UIColor {
    convenience init(colorCode: String, alpha: Float = 1.0) {
        let scanner = Scanner(string: colorCode)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
        let b = CGFloat(Float(Int(color) & mask) / 255.0)
        
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
#endif
