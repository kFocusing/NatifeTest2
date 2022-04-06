//
//  PostListPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol PostListViewProtocol: AnyObject {
    func update()
    func displayError(_ error: String?)
}

protocol PostListPresenterProtocol: AnyObject {
    init(view: PostListViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol)
    func item(at index: Int) -> PreviewPostModel?
    func itemsCount() -> Int
    func viewDidLoad()
    var posts: [PreviewPostModel]? { get set }
    func tapPostDetail(postID: Int)
}

class PostListPresenter: PostListPresenterProtocol {
    
    //MARK: - Variables -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let postsService: PostsServiceProtocol!
    var posts: [PreviewPostModel]?
    
    //MARK: - Life Cycle -
    required init(view: PostListViewProtocol,
                  postsService: PostsServiceProtocol,
                  router: RouterProtocol) {
        self.postsService = postsService
        self.view = view
        self.router = router
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getPreviewPosts()
    }
    
    func item(at index: Int) -> PreviewPostModel? {
        guard let posts = posts else { return nil }
        return posts[index]
    }
    
    func itemsCount() -> Int {
        return posts?.count ?? 0
    }
    
    func tapPostDetail(postID: Int) {
        router?.showPostDetailViewController(postID: postID)
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        postsService.fetchPostList(route: "main.json") { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts.posts
                self?.view?.update()
            case .failure(let error):
                self?.view?.displayError(error.message)
            }
        }
    }
}
