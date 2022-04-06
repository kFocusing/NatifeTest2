//
//  PostXibTableViewCell.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostXibTableViewCell: BaseTableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewTextLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    //MARK: - Variables -
    var updateIsExpended: ((_ postID: Int) -> Void)?
    var readMoreTapped: (() -> Void)?
    private var post: PreviewPostModel?
    
    //MARK: - Internal -
    func configure(post: PreviewPostModel?) {
        self.post = post
        configureTextFields()
        configureExpandButton()
    }
    
    //MARK: - Private -
    @IBAction private func readMoreButtonPressed(_ sender: Any) {
        guard var post = self.post else { return }
        post.isExpanded ? shortenText() : expandedText()
        updateLayout()
        
        updateIsExpended?(post.postID)
        post.isExpanded.toggle()
        self.post = post
    }
   
    private func configureTextFields() {
        titleLabel.text = post?.title ?? ""
        previewTextLabel.text = post?.previewText ?? ""
        publishDateLabel.text = post?.timeshamp.timeshampToDateString() ?? ""
        likesCount.text = String(post?.likesCount ?? 0)
    }
    
    private func expandedText() {
        previewTextLabel.numberOfLines = 0
        readMoreButton.setTitle("Свернуть текст", for: .normal)
    }
    
    private func shortenText() {
        previewTextLabel.numberOfLines = 2
        readMoreButton.setTitle("Читать далее...", for: .normal)
    }
    
    private func configureExpandButton() {
        guard let post = self.post else { return }
        post.isExpanded ? expandedText() : shortenText()
        readMoreButton.isHidden = previewTextLabel.numberLinesOfText <= 2
    }
    
    private func updateLayout() {
        readMoreTapped?()
    }
}

