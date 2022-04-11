//
//  PreviewPostCollectionViewCell.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 11.04.2022.
//

import UIKit

class PreviewPostCollectionViewCell: BaseDynamicHeightCollectionCell {
    
    //MARK: - UIElements -
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewTextLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    //MARK: - Variables -
    private var readMoreTapped: EmptyBlock?
    private let maximumNumberOfLinesCollapsed = 2
    
    //MARK: - Internal -
    func configure(post: PreviewPostModel?, readMoreTapped: EmptyBlock?) {
        self.readMoreTapped = readMoreTapped
        configureTextFields(post: post)
        configure(post?.isExpanded ?? false)
    }
    
    //MARK: - Private -
    @IBAction private func readMoreButtonPressed(_ sender: Any) {
        readMoreTapped?()
    }
    
    private func configureTextFields(post: PreviewPostModel?) {
        titleLabel.text = post?.title ?? ""
        previewTextLabel.text = post?.previewText ?? ""
        publishDateLabel.text = post?.timeshamp.timeshampToDateString() ?? ""
        likesCount.text = String(post?.likesCount ?? 0)
    }
    
    private func configure(_ isExpanded: Bool) {
        isExpanded ? setup(for: .fullPreview) : setup(for: .shortPreview)
        readMoreButton.isHidden = previewTextLabel.numberOfTextLines <= maximumNumberOfLinesCollapsed
    }
    
    private func setup(for displayingMode: PreviewTextDisplayingMode) {
        switch displayingMode {
        case .shortPreview:
            previewTextLabel.numberOfLines = maximumNumberOfLinesCollapsed
            readMoreButton.setTitle("Читать далее...", for: .normal)
        case .fullPreview:
            previewTextLabel.numberOfLines = 0
            readMoreButton.setTitle("Свернуть текст", for: .normal)
        }
    }
}
