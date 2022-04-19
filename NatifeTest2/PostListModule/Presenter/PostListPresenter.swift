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
    func search(with searhText: String)
}

class PostListPresenter: PostListPresenterProtocol {
    
    //MARK: - Properties -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let postsService: PostsServiceProtocol!
    private var posts: [PreviewPostModel]
    private var searchResults: [PreviewPostModel] 
    private var dataSource: [PreviewPostModel] {
        return isSearchActive ? searchResults : posts
    }
    private var searchText = ""
    private var isSearchActive: Bool {
        return searchText.isNotEmpty()
    }
    
    //MARK: - Life Cycle -
    required init(view: PostListViewProtocol,
                  postsService: PostsServiceProtocol,
                  router: RouterProtocol) {
        self.postsService = postsService
        self.view = view
        self.router = router
        self.posts = []
        self.searchResults = []
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getPreviewPosts()
    }
    
    func getPost(at index: Int) -> PreviewPostModel? {
        return dataSource[index]
    }
    
    func search(with searhText: String) {
        searchText = searhText
        updateSearchResults()
    }
    
    func itemsCount() -> Int {
        return dataSource.count
    }
    
    func showPostDetail(with postID: Int) {
        router?.showPostDetailViewController(with: postID)
    }
    
    func toglePostIsExpanded(for index: Int) {
        guard let postIndex = dataSource.firstIndex(where: {
            post in post == getPost(at: index)
        }) else {
            return
        }
        switch isSearchActive {
        case true:
            searchResults[postIndex].isExpanded.toggle()
        case false:
            posts[postIndex].isExpanded.toggle()
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
    
    private func updateSearchResults() {
        searchResults = posts.filter({ (post: PreviewPostModel) -> Bool in
            return post.title.lowercased().contains(searchText.lowercased())
        })
        view?.update()
    }
}

enum SortType {
    case defaultSort
    case ratingSort
    case dateSort
}
