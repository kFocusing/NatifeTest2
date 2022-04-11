//
//  GalleryPreviewCollectionViewCell.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 11.04.2022.
//

import UIKit

class GridPreviewPostCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - UIElements -
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewTextLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    
    
    //MARK: - Internal -
    func configure(post: PreviewPostModel?) {
        self.backgroundColor = .white
        configureTextFields(post: post)
    }
    
    //MARK: - Private -
    private func configureTextFields(post: PreviewPostModel?) {
        titleLabel.text = post?.title ?? ""
        previewTextLabel.text = post?.previewText ?? ""
        publishDateLabel.text = post?.timeshamp.timeshampToDateString() ?? ""
        likesCount.text = String(post?.likesCount ?? 0)
    }
}
