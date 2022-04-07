//
//  PostDetailPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

protocol PostDetailViewProtocol: AnyObject {
    func update(with detailsModel: DetailPostModel)
    func displayError(_ error: String?)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol PostDetailViewPresenterProtocol: AnyObject {
    init(view: PostDetailViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol,
         postID: Int)
    func viewDidLoad()
}

class PostDetailPresenter: PostDetailViewPresenterProtocol {
    
    //MARK: - Variables -
    private weak var view: PostDetailViewProtocol?
    private var router: RouterProtocol?
    private let postsService: PostsServiceProtocol!
    private var postID: Int
    private var detailPost: DetailPostModel?
    
    //MARK: - Life Cycle -
    required init(view: PostDetailViewProtocol,
                  postsService: PostsServiceProtocol,
                  router: RouterProtocol,
                  postID: Int) {
        self.view = view
        self.postsService = postsService
        self.postID = postID
        self.router = router
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getDetailPost(postID: postID)
    }
    
    //MARK: - Private - 
    private func getDetailPost(postID: Int) {
        showLoader()
        postsService.fetchPost(route: "posts/\(postID).json") { [weak self] post, error in
            if let post = post {
                DispatchQueue.main.async {
                    self?.detailPost = post.post
                    self?.view?.update(with: post.post)
                    self?.hideLoader()
                }
            } else {
                self?.view?.displayError(error?.message)
            }
        }
    }
    
    private func showLoader() {
        view?.showActivityIndicator()
    }
    
    private func hideLoader() {
        view?.hideActivityIndicator()
    }
}

