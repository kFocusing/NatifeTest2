//
//  Router.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblyBuilderProtocol { get set }
}

protocol RouterProtocol: RouterMain {
    func showPostListViewController()
    func showPostDetailViewController(with postID: Int)
    func popToRoot()
}

class Router: RouterProtocol {
    
    //MARK: - Variables -
    var assemblyBuilder: AssemblyBuilderProtocol
    var navigationController: UINavigationController?
    
    //MARK: - Life Cycle -
    init(navigationController: UINavigationController,
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Internal -
    func showPostListViewController() {
        navigationController?.viewControllers = [assemblyBuilder.createPostListModule(router: self)]
    }
    
    func showPostDetailViewController(with postID: Int) {
        navigationController?.pushViewController( assemblyBuilder.createPostDetailModule(router: self,
                                                                                         postID: postID),
                                                 animated: true)
    }
    
    func popToRoot() {
        navigationController?.popViewController(animated: true)
    }
}
