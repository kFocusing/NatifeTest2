//
//  PostDetailViewController.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

class PostDetailViewController: UIViewController {
    
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.isHidden = true
        scrollView.addSubview(titleLabel)
        return titleLabel
    }()
    private lazy var detailTextLabel: UILabel = {
        let detailTextLabel = UILabel()
        detailTextLabel.translatesAutoresizingMaskIntoConstraints = false
        detailTextLabel.numberOfLines = 0
        detailTextLabel.isHidden = true
        scrollView.addSubview(detailTextLabel)
        return detailTextLabel
    }()
    private lazy var likesCountLabel: UILabel = {
        let likesCountLabel = UILabel()
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        likesCountLabel.font = .boldSystemFont(ofSize: 17)
        likesCountLabel.isHidden = true
        scrollView.addSubview(likesCountLabel)
        return likesCountLabel
    }()
    private lazy var publishDateLabel: UILabel = {
        let publishDateLabel = UILabel()
        publishDateLabel.translatesAutoresizingMaskIntoConstraints = false
        publishDateLabel.font = .boldSystemFont(ofSize: 17)
        publishDateLabel.isHidden = true
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
        stackView.isHidden = true
        scrollView.addSubview(stackView)
        return stackView
    }()
    private lazy var likeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "heart")
        image.tintColor = UIColor(red: 183/255, green: 4/255, blue: 0/255, alpha: 1)
        image.isHidden = true
        scrollView.addSubview(image)
        return image
    }()
    private lazy var activityIndicator: UIActivityIndicatorView! = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    var presenter: PostDetailViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUIElements()
        self.startActivityIndicator()
        view.backgroundColor = .white
        presenter.viewDidLoad()
        
    }
    
    //MARK: - Internal - 
    func configureUIElements(detailPost: DetailPostModel) {
        DispatchQueue.main.async {
            self.configureTitleLabel(post: detailPost)
            self.configureDetailTextLabel(post: detailPost)
            self.configureLikesCountLabel(post: detailPost)
            self.configurePublishDateLabel(post: detailPost)
            self.configureImageStackView(post: detailPost)
            self.unHideUIElements()
            self.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: - Private -
    private func layoutUIElements() {
        layoutScrollView()
        layoutActivityIndicator()
        layoutTitleLabel()
        layoutDetailTextLabel()
        layoutImageStackView()
        layoutLikeImage()
        layoutLikesCountLabel()
        layoutPublishDateLabel()
    }
    
    private func layoutScrollView() {
        scrollView.pinEdges(to: view)
    }
    
    private func layoutTitleLabel() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
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
    
    private func layoutActivityIndicator() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureTitleLabel(post: DetailPostModel) {
        titleLabel.text = post.title
    }
    
    private func configureDetailTextLabel(post: DetailPostModel) {
        detailTextLabel.text = post.text
    }
    
    private func configureLikesCountLabel(post: DetailPostModel) {
        likesCountLabel.text = String(post.likesCount)
    }
    
    private func configurePublishDateLabel(post: DetailPostModel) {
        publishDateLabel.text = post.timeshamp.timeshampToDateString()
    }
    
    private func configureImageStackView(post: DetailPostModel) {
        for imageURL in post.images {
            guard let url = URL(string: imageURL),
                  let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }
            let imageView = UIImageView(image: image)
            layoutImageIntoImagesStackView(imageView: imageView)
        }
    }
    
    private func layoutImageIntoImagesStackView(imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        imagesStackView.addArrangedSubview(imageView)
    }
    
    private func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    private func unHideUIElements() {
        titleLabel.isHidden.toggle()
        detailTextLabel.isHidden.toggle()
        publishDateLabel.isHidden.toggle()
        likeImage.isHidden.toggle()
        likesCountLabel.isHidden.toggle()
        imagesStackView.isHidden.toggle()
    }
}

extension PostDetailViewController: PostDetailViewProtocol { }

