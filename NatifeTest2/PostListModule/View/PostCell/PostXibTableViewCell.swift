//
//  ViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol UpdateCellSizeDelegate: AnyObject {
    func readMoreTapped()
    func updateIsExpended(withID id: Int)
}

class PostXibTableViewCell: BaseTableViewCell {
    
    //MARK: - IBOutlet -
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var previewTextLabel: UILabel!
    @IBOutlet private weak var publishDateLabel: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    weak var delegate: UpdateCellSizeDelegate?
    private var post: PreviewPostModel?
    
    //MARK: - Internal -
    func configure(post: PreviewPostModel) {
        self.post = post
        setTitle()
        setText()
        setLikesCount()
        setPublishDate()
        configureExpandButton()
    }
    
    //MARK: - Private -
    @IBAction func readMoreButtonPressed(_ sender: Any) {
        guard var post = self.post, let delegate = delegate  else { return }
        if post.isExpended {
            previewTextLabel.numberOfLines = 2
            readMoreButton.setTitle("Читать далее...", for: .normal)
        } else {
            previewTextLabel.numberOfLines = 0
            readMoreButton.setTitle("Свернуть текст", for: .normal)
        }
        updateLayout()
        post.isExpended = !post.isExpended
        delegate.updateIsExpended(withID: post.postID)
        self.post = post
    }
    
    //MARK: - Private -
    private func setTitle() {
        guard let post = post else { return }
        titleLabel.text = post.title
    }
    
    private func setText() {
        guard let post = post else { return }
        previewTextLabel.text = post.previewText
    }
    
    private func setPublishDate() {
        guard let post = post else { return }
        publishDateLabel.text = post.timeshamp.timeshampToDateString()
    }
    
    private func setLikesCount() {
        guard let post = post else { return }
        likesCount.text = String(post.likesCount)
    }
    
    private func configureExpandButton() {
        guard let post = self.post else { return }
        if post.isExpended {
            previewTextLabel.numberOfLines = 0
            readMoreButton.setTitle("Свернуть текст", for: .normal)
        } else {
            previewTextLabel.numberOfLines = 2
            readMoreButton.setTitle("Читать далее...", for: .normal)
        }
        readMoreButton.isHidden = previewTextLabel.maxNumberOfLines <= 2
    }
    
    private func updateLayout() {
        delegate?.readMoreTapped()
    }
}
