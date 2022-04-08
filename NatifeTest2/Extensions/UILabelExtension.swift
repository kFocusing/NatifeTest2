//
//  UILabelExtension.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 08.04.2022.
//


import UIKit

extension UILabel {
    var countLinesOfLabel: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
