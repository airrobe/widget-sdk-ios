//
//  UILabel+UnderlineText.swift
//  
//
//  Created by King on 9/20/22.
//

import UIKit

extension UILabel {

    func underlineText() {
        guard let text = text else { return }
        let textRange = NSRange(location: 0, length: text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(.underlineStyle,
                                    value: NSUnderlineStyle.single.rawValue,
                                    range: textRange)
        self.attributedText = attributedText
    }

}
