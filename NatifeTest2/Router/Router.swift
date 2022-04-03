//
//  Router.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func showPostListViewController()
    func showPostDetailViewController(post: PostModel)
    func popToRoot()
}

class Router: RouterProtocol {
    
    //MARK: - Variables -
    var assemblyBuilder: AssemblyBuilderProtocol?
    var navigationController: UINavigationController?
    
    //MARK: - Life Cycle -
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Internal -
    func showPostListViewController() {
        guard let postListViewController =
                assemblyBuilder?.createPostListModule(router: self) else { return }
        navigationController?.viewControllers = [postListViewController]
    }
    
    func showPostDetailViewController(post: PostModel) {
        guard let postDetailViewController =
                assemblyBuilder?.createPostDetailModule(router: self,
                                                       post: post) else { return }
        navigationController?.pushViewController(postDetailViewController,
                                                 animated: true)
    }
    
    func popToRoot() {
        navigationController?.popViewController(animated: true)
    }
}
