//
//  String+Extensions.swift
//  
//
//  Created by King on 1/11/22.
//

import Foundation
import UIKit

extension String {
    func width(withFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes)
    }
}
