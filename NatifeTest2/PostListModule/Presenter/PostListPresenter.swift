//
//  PostListPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol PostListViewProtocol: AnyObject {
    func setupTableView()
}

protocol PostListPresenterProtocol: AnyObject {
    init(view: PostListViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol)
    func item(at index: Int) -> PreviewPostModel
    func itemsCount() -> Int
    func viewDidLoad()
    func tapPostDetail(postID: Int)
    var posts: [PreviewPostModel]! { get set }
}

class PostListPresenter: PostListPresenterProtocol {
    
    //MARK: - Variables -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let postsService: PostsServiceProtocol!
    var posts: [PreviewPostModel]!
    
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
        getPosts()
    }
    
    func item(at index: Int) -> PreviewPostModel {
        return posts[index]
    }
    
    func itemsCount() -> Int {
        return posts.count
    }
    
    func tapPostDetail(postID: Int) {
        router?.showPostDetailViewController(postID: postID)
    }
    
    //MARK: - Private -
    private func getPosts() {
        postsService.fetchPost(route: "main.json",
                               expacting: PreviewPostListModel.self) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts.posts
                self?.view?.setupTableView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
