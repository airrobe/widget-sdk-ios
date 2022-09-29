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

    enum AirRobeColors {
        enum Default {
            static let BorderColor = UIColor(colorCode: "DFDFDF")
            static let TextColor = UIColor(colorCode: "232323")
            static let SwitchOnTintColor = UIColor(colorCode: "42ABC8")
            static let SwitchOffTintColor = UIColor(colorCode: "DFDFDF")
            static let ArrowColor = UIColor(colorCode: "42ABC8")
            static let LinkTextColor = UIColor(colorCode: "696969")
            static let ConfirmationButtonBorderColor = UIColor(colorCode: "232323")
            static let ConfirmationButtonBackgroudColor = UIColor(colorCode: "FFFFFF")
            static let ConfirmationButtonTextColor = UIColor(colorCode: "232323")
            static let SeparatorColor = UIColor(colorCode: "DFDFDF")
        }
        enum Enhanced {
            static let BorderColor = UIColor(colorCode: "000000")
            static let TextColor = UIColor(colorCode: "222222")
            static let SwitchOnTintColor = UIColor(colorCode: "222222")
            static let SwitchOffTintColor = UIColor(colorCode: "FFFFFF")
            static let SwitchThumbOnTintColor = UIColor(colorCode: "FFFFFF")
            static let SwitchThumbOffTintColor = UIColor(colorCode: "222222")
            static let SwitchBorderColor = UIColor(colorCode: "B2B2B2")
            static let PopupSwitchContainerBackgroundColor = UIColor(colorCode: "F1F1F1")
            static let ArrowColor = UIColor(colorCode: "222222")
            static let LinkTextColor = UIColor(colorCode: "222222")
            static let ConfirmationButtonBorderColor = UIColor(colorCode: "FFFFFF", alpha: 0)
            static let ConfirmationButtonBackgroudColor = UIColor(colorCode: "111111")
            static let ConfirmationButtonTextColor = UIColor(colorCode: "FFFFFF")
            static let SeparatorColor = UIColor(colorCode: "222222")
        }
    }
}
#endif
