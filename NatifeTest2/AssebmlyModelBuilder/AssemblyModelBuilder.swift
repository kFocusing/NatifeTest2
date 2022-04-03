//
//  AssemblyModelBuilder.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import UIKit

protocol AssemblyBuilderProtocol {
    func createPostListModule(router: RouterProtocol) -> UIViewController
    func createPostDetailModule(router: RouterProtocol, post: PostModel) -> UIViewController
}

class AssemblyModelBuilder: AssemblyBuilderProtocol {
//    func createPostListModule(router: RouterProtocol) -> UIViewController {
//        return UIViewController()
//    }
    
    func createPostDetailModule(router: RouterProtocol, post: PostModel) -> UIViewController {
        return UIViewController()
    }
    
    
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

//    func createPostDetailModule(router: RouterProtocol,
//                            post: PostModel) -> UIViewController {
//        let view = PostDetailViewController()
//        let presenter = PostDetailPresenter(view: view,
//                                        router: router,
//                                        post: PostModel)
//        view.presenter = presenter
//        return view
//    }
}
