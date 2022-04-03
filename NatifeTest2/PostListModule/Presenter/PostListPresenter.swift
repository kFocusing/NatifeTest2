//
//  PostListPresenter.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation
import UIKit

protocol PostListViewProtocol: AnyObject {
    func setupTableView()
}

protocol PostListPresenterProtocol: AnyObject {
    init(view: PostListViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol)
    func item(at index: Int) -> PostModel
    func itemsCount() -> Int
    func viewDidLoad()
    var posts: [PostModel]! { get set }
}

class PostListPresenter: PostListPresenterProtocol {
    //MARK: - Variables -
    weak var view: PostListViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    var posts: [PostModel]!
    
    //MARK: - Life Cycle -
    required init(view: PostListViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol) {
        self.networkService = networkService
        self.view = view
        self.router = router
    }
    
    func viewDidLoad() {
        getPosts()
    }
    
    private func getPosts() {
        let URLString = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/main.json"
        guard let url = URL(string: URLString) else { return }
        networkService.getData(url: url, expacting: PostListModel.self) { [weak self] result in
            switch result {
            case .success(let posts):
                self?.posts = posts.posts
                self?.view?.setupTableView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tapOnTheComment(post: PostModel) {
        router?.showPostDetailViewController(post: post)
    }
    
    func item(at index: Int) -> PostModel {
        return posts[index]
    }
    
    func itemsCount() -> Int {
        return posts.count
    }
}
