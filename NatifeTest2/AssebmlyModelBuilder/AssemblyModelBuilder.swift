//
//  AssemblyModelBuilder.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createPostListModule(router: RouterProtocol) -> UIViewController
    func createPostDetailModule(router: RouterProtocol, postID: Int) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
    
    //MARK: - Internal -
    func createPostListModule(router: RouterProtocol) -> UIViewController {
        let view = PostListViewController()
        let networkService = NetworkService()
        let presenter = PostListPresenter(view: view,
                                          networkService: networkService,
                                          router: router)
        view.presenter = presenter
        return view
    }
    
    func createPostDetailModule(router: RouterProtocol,
                                postID: Int) -> UIViewController {
        let view = PostDetailViewController()
        let networkService = NetworkService()
        let presenter = PostDetailPresenter(view: view,
                                            networkService: networkService,
                                            router: router,
                                            postID: postID)
        view.presenter = presenter
        return view
    }
}
