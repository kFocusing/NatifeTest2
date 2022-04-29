//
//  PostDetailViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostDetailViewController: BaseViewController {
    
    //MARK: - Variables -
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.showsHorizontalScrollIndicator = true
        scroll.showsVerticalScrollIndicator = true
        view.addSubview(scroll)
        return scroll
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        scrollView.addSubview(titleLabel)
        return titleLabel
    }()
    private lazy var detailTextLabel: UILabel = {
        let detailTextLabel = UILabel()
        detailTextLabel.text = ""
        detailTextLabel.textColor = .black
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel.numberOfLines = 0
        scrollView.addSubview(detailTextLabel)
        return detailTextLabel
    }()
    private lazy var likesCountLabel: UILabel = {
        let likesCountLabel = UILabel()
        likesCountLabel.text = ""
        likesCountLabel.textColor = .black
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likesCountLabel.font = .boldSystemFont(ofSize: 17)
        scrollView.addSubview(likesCountLabel)
        return likesCountLabel
    }()
    private lazy var publishDateLabel: UILabel = {
        let publishDateLabel = UILabel()
        publishDateLabel.text = ""
        publishDateLabel.textColor = .black
        publishDateLabel.translatesAutoresizingMaskIntoConstraints = false
        publishDateLabel.font = .boldSystemFont(ofSize: 17)
        publishDateLabel.textAlignment = .right
        scrollView.addSubview(publishDateLabel)
        return publishDateLabel
    }()
    private lazy var imagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        return stackView
    }()
    private lazy var likeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = .none
        image.tintColor = .burgundyRed
        scrollView.addSubview(image)
        return image
    }()
    
    var presenter: PostDetailViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        view.backgroundColor = .white
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func layoutUIElements() {
        layoutScrollView()
        layoutTitleLabel()
        layoutDetailTextLabel()
        layoutImageStackView()
        layoutLikeImage()
        layoutLikesCountLabel()
        layoutPublishDateLabel()
    }
    
    private func configureDetailView(with post: DetailPostModel) {
        titleLabel.text = post.title
        detailTextLabel.text = post.text
        likeImage.image = UIImage(systemName: "heart")
        likesCountLabel.text = String(post.likesCount)
        publishDateLabel.text = Date.timeshampToDateString(post.timeshamp)
    }
    
    private func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func layoutTitleLabel() {
        let horizontalInset: CGFloat = 30
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalInset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalInset)
        ])
    }
    
    private func layoutDetailTextLabel() {
        NSLayoutConstraint.activate([
            detailTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailTextLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func layoutImageStackView() {
        NSLayoutConstraint.activate([
            imagesStackView.topAnchor.constraint(equalTo: detailTextLabel.bottomAnchor, constant: 10),
            imagesStackView.leadingAnchor.constraint(equalTo: detailTextLabel.leadingAnchor),
            imagesStackView.trailingAnchor.constraint(equalTo: detailTextLabel.trailingAnchor)
        ])
    }
    
    private func layoutLikeImage() {
        NSLayoutConstraint.activate([
            likeImage.topAnchor.constraint(equalTo: imagesStackView.bottomAnchor, constant: 10),
            likeImage.leadingAnchor.constraint(equalTo: imagesStackView.leadingAnchor),
            likeImage.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            likeImage.widthAnchor.constraint(equalToConstant: 20),
            likeImage.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func layoutLikesCountLabel() {
        NSLayoutConstraint.activate([
            likesCountLabel.topAnchor.constraint(equalTo: imagesStackView.bottomAnchor, constant: 10),
            likesCountLabel.leadingAnchor.constraint(equalTo: likeImage.trailingAnchor, constant: 3),
            likesCountLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            likesCountLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func layoutPublishDateLabel() {
        NSLayoutConstraint.activate([
            publishDateLabel.topAnchor.constraint(equalTo: imagesStackView.bottomAnchor, constant: 10),
            publishDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            publishDateLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            publishDateLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func getImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imagesStackView.frame.width)
        ])
        return imageView
    }
}

// MARK: - PostDetailViewProtocol -
extension PostDetailViewController: PostDetailViewProtocol {
    
    func update(with detailsModel: DetailPostModel) {
        DispatchQueue.main.async { [weak self] in
            self?.configureDetailView(with: detailsModel)
        }
    }
    
    func displayImages(_ images: [UIImage]) {
        for image in images {
            DispatchQueue.main.async { [weak self] in
                guard let imageView = self?.getImageView(with: image) else { return }
                self?.imagesStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    func displayError(_ error: String) {
        configureErrorAlert(with: error)
    }
}

