//
//  PostDetailPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

protocol PostDetailViewProtocol: AnyObject {
    func configureUIElements(detailPost: DetailPostModel)
}

protocol PostDetailViewPresenterProtocol: AnyObject {
    init(view: PostDetailViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol,
         postID: Int)
    func getDetailPost(postID: Int)
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
        getDetailPost(postID: postID)
    }
    
    func getDetailPost(postID: Int) {
        postsService.fetchPost(route: "posts/\(postID).json",
                               expacting: DetailPostModelRequest.self) { [weak self] result in
            switch result {
            case .success(let post):
                self?.detailPost = post.post
                self?.view?.configureUIElements(detailPost: post.post)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
