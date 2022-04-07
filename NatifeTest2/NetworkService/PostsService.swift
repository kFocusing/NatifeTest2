//
//  PostsService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 05.04.2022.
//

import Foundation

protocol PostsServiceProtocol {
    func fetchPost(route: String, completion: @escaping (DetailPostModelRequest?, CustomError?) -> ())
    func fetchPostLists(route: String, completion: @escaping (PreviewPostListModel?, CustomError?) -> ())
}

class BasePostsService {
    func parseJson<T: Codable>(_ data: Data, expecting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expecting, from: data)
            return decodateData
        } catch {
            return nil
        }
    }
}


class PostsService: BasePostsService, PostsServiceProtocol {
    
    //MARK: - Internal -
    func fetchPost(route: String, completion: @escaping (DetailPostModelRequest?, CustomError?) -> ()) {
        NetworkService.shared.request(route: route) { result in
            switch result {
            case .success(let data):
                let postResponse = self.parseJson(data, expecting: DetailPostModelRequest.self)
                completion(postResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchPostLists(route: String, completion: @escaping (PreviewPostListModel?, CustomError?) -> ()) {
        NetworkService.shared.request(route: route) { result in
            switch result {
            case .success(let data):
                let postListResponse = self.parseJson(data, expecting: PreviewPostListModel.self)
                completion(postListResponse, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
