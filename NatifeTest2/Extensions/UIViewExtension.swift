//
//  UIViewExtension.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

// MARK: - Layout -
extension UIView {
    //MARK: - Anchors -
    func pinEdges(to superView: UIView?,
                  topSpace: CGFloat = .zero,
                  leftSpace: CGFloat = .zero,
                  rightSpace: CGFloat = .zero,
                  bottomSpace: CGFloat = .zero) {
        guard let view = superView else {return}
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: topSpace),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftSpace),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -rightSpace),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomSpace)
        ])
        view.setNeedsLayout()
    }
    
    func alignCentered(subview: UIView?,
                       xOffset: CGFloat = .zero,
                       yOffset: CGFloat = .zero) {
        guard let subview = subview else {return}
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xOffset),
            subview.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yOffset)
        ])
        setNeedsLayout()
    }
}
