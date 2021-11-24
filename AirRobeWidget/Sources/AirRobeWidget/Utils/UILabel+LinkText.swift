//
//  UILabel+LinkText.swift
//  
//
//  Created by King on 11/24/21.
//

#if canImport(UIKit)
import UIKit

extension UILabel {
    func setLinkText(orgText: String, linkText: String, link: String) {
        var attText: NSMutableAttributedString? = NSMutableAttributedString(string: orgText)
        let linkWasSet = attText?.setAsLink(textToFind: linkText, linkURL: link) == true
        if !linkWasSet {
            attText = nil
        }
        attributedText = attText
    }
}
#endif
