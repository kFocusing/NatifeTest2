//
//  BaseDynamicHeightCollectionViewCell.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 11.04.2022.
//

import UIKit

class BaseDynamicHeightCollectionCell: BaseCollectionViewCell {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width,
                                height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
