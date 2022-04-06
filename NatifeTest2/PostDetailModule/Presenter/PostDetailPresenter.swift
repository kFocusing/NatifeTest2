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
    
    //MARK: Internal
    func viewDidLoad() {
        view?.showActivityIndicator()
        getDetailPost(postID: postID)
    }
    
    private func getDetailPost(postID: Int) {
        postsService.fetchPost(route: "posts/\(postID).json") { [weak self] result in
            switch result {
            case .success(let post):
                self?.detailPost = post.post
                self?.view?.update(with: post.post)
            case .failure(let error):
                self?.view?.displayError(error.message)
            }
        }
    }
}
