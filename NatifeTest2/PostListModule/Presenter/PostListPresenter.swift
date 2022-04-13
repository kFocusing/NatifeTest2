//
//  PostListPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol PostListViewProtocol: AnyObject {
    func update()
    func displayError(_ error: String)
    func showActivityIndicator()
    func hideActivityIndicator()
}

protocol PostListPresenterProtocol: AnyObject {
    init(view: PostListViewProtocol,
         postsService: PostsServiceProtocol,
         router: RouterProtocol)
    func getPost(at index: Int) -> PreviewPostModel?
    func itemsCount() -> Int
    func viewDidLoad()
    func showPostDetail(with postID: Int)
    func toglePostIsExpanded(for index: Int)
    func sortPosts(by criterion: SortType)
    func searchPost(by searchText: String)
    func filtredItemsCount() -> Int
    func getFilterPost(at index: Int) -> PreviewPostModel?
}

class PostListPresenter: PostListPresenterProtocol {
    
    //MARK: - Variables -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let postsService: PostsServiceProtocol!
    private var posts: [PreviewPostModel]
    private var filtredPost: [PreviewPostModel]
    
    //MARK: - Life Cycle -
    required init(view: PostListViewProtocol,
                  postsService: PostsServiceProtocol,
                  router: RouterProtocol) {
        self.postsService = postsService
        self.view = view
        self.router = router
        self.posts = []
        self.filtredPost = []
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getPreviewPosts()
    }
    
    func getPost(at index: Int) -> PreviewPostModel? {
        return posts[index]
    }
    
    func getFilterPost(at index: Int) -> PreviewPostModel? {
        return filtredPost[index]
    }
    
    func itemsCount() -> Int {
        return posts.count
    }
    
    func filtredItemsCount() -> Int {
        return filtredPost.count
    }
    
    
    func showPostDetail(with postID: Int) {
        router?.showPostDetailViewController(with: postID)
    }
    
    func toglePostIsExpanded(for index: Int) {
        guard let postIndex = posts.firstIndex(where: {
            post in post == getPost(at: index)
        }) else {
            return
        }
        posts[postIndex].isExpanded.toggle()
        if !filtredPost.isEmpty {
            filtredPost[postIndex].isExpanded.toggle()
        }
        view?.update()
    }
    
    func sortPosts(by criterion: SortType) {
        switch criterion {
        case .dateSort:
            posts = posts.sorted(by: { $0.timeshamp > $1.timeshamp })
        case .ratingSort:
            posts = posts.sorted(by: { $0.likesCount > $1.likesCount })
        case .defaultSort:
            posts = posts.sorted(by: { $0.postID < $1.postID })
        }
        view?.update()
    }
    
    func searchPost(by searchText: String) {
        filtredPost = posts.filter({ (post: PreviewPostModel) -> Bool in
            return post.title.lowercased().contains(searchText.lowercased())
        })
    }
    
    //MARK: - Private -
    private func getPreviewPosts() {
        self.view?.showActivityIndicator()
        postsService.fetchPostLists(route: "main.json") {  [weak self] response, error in
            self?.view?.hideActivityIndicator()
            if let response = response {
                DispatchQueue.main.async { [weak self] in
                    self?.posts = response.posts
                    self?.view?.update()
                }
            } else {
                guard let error = error?.message else {
                    self?.view?.displayError("Unknown Error")
                    return
                }
                self?.view?.displayError(error)
            }
        }
    }
}

enum SortType {
    case defaultSort
    case ratingSort
    case dateSort
}
