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

    static var AirRobeDefaultBorderColor: UIColor {
        return UIColor(colorCode: "DFDFDF")
    }

    static var AirRobeDefaultTextColor: UIColor {
        return UIColor(colorCode: "232323")
    }

    static var AirRobeDefaultSwitchColor: UIColor {
        return UIColor(colorCode: "42abc8")
    }

    static var AirRobeDefaultArrowColor: UIColor {
        return UIColor(colorCode: "42abc8")
    }

    static var AirRobeDefaultLinkTextColor: UIColor {
        return UIColor(colorCode: "696969")
    }

    static var AirRobeDefaultButtonBorderColor: UIColor {
        return UIColor(colorCode: "232323")
    }

    static var AirRobeDefaultButtonTextColor: UIColor {
        return UIColor(colorCode: "232323")
    }

    static var AirRobeDefaultSeparatorColor: UIColor {
        return UIColor(colorCode: "DFDFDF")
    }

    static var AirRobeDefaultBorderColorVariant2: UIColor {
        return UIColor(colorCode: "000000")
    }

    static var AirRobeDefaultTextColorVariant2: UIColor {
        return UIColor(colorCode: "222222")
    }

    static var AirRobeDefaultSwitchColorVariant2: UIColor {
        return UIColor(colorCode: "222222")
    }

    static var AirRobeDefaultArrowColorVariant2: UIColor {
        return UIColor(colorCode: "222222")
    }

    static var AirRobeDefaultLinkTextColorVariant2: UIColor {
        return UIColor(colorCode: "222222")
    }

    static var AirRobeDefaultButtonBorderColorVariant2: UIColor {
        return UIColor(colorCode: "111111")
    }

    static var AirRobeDefaultButtonTextColorVariant2: UIColor {
        return UIColor(colorCode: "ffffff")
    }

    static var AirRobeDefaultSeparatorColorVariant2: UIColor {
        return UIColor(colorCode: "222222")
    }
}
#endif
