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
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol PostListPresenterProtocol: AnyObject {
    init(view: PostListViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol)
    func item(at index: Int) -> PreviewPostModel?
    func itemsCount() -> Int
    func viewDidLoad()
    func showPostDetail(with postID: Int)
    func toglePostIsExpanded(for id: Int)
    func sortPosts(by criterion: SortEnum)
}

class PostListPresenter: PostListPresenterProtocol {
    
    //MARK: - Variables -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let postsService: PostsServiceProtocol!
    private var posts: [PreviewPostModel]?
    
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
    
    func showPostDetail(with postID: Int) {
        router?.showPostDetailViewController(with: postID)
    }
    
    func toglePostIsExpanded(for id: Int) {
        guard let postIndex = posts?.firstIndex(where: { post in post.postID == id }) else { return }
        posts?[postIndex].isExpanded.toggle()
        view?.update()
    }
    
    func sortPosts(by criterion: SortEnum) {
        switch criterion {
        case .dateSort:
            posts = posts?.sorted(by: { $0.timeshamp > $1.timeshamp })
        case .ratingSort:
            posts = posts?.sorted(by: { $0.likesCount > $1.likesCount })
        case .defaultSort:
            posts = posts?.sorted(by: { $0.postID < $1.postID })
        }
        view?.update()
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        showLoader()
        postsService.fetchPostLists(route: "main.json") {  [weak self] response, error in
            if let response = response {
                DispatchQueue.main.async {
                    self?.posts = response.posts
                    self?.view?.update()
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

enum SortEnum {
    case defaultSort
    case ratingSort
    case dateSort
}
