//
//  PostsService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 05.04.2022.
//

import Foundation

protocol PostsServiceProtocol {
//    func fetchPost<T: Codable>(route: String,
//                               expacting: T.Type,
//                               completion: @escaping (Result<T, Error>) -> Void)
    
    
    func fetchPost(route: String, completion: @escaping (Result<DetailPostModelRequest, CustomError>) -> Void)
    func fetchPostList(route: String, completion: @escaping (Result<PreviewPostListModel, CustomError>) -> Void)
}

class BasePostsService {
    func parseJson<T: Codable>(_ data: Data, expacting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expacting, from: data)
            return decodateData
        } catch {
            return nil
        }
    }
}


class PostsService: BasePostsService, PostsServiceProtocol {
    
    //MARK: - Internal -
    func fetchPost(route: String,
                   completion: @escaping (Result<DetailPostModelRequest, CustomError>) -> Void) {
        NetworkService.shared.request(route: route) { result in
            switch result {
            case .success(let data):
                if let postResponse = self.parseJson(data, expacting: DetailPostModelRequest.self) {
                    completion(.success(postResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPostList(route: String,
                   completion: @escaping (Result<PreviewPostListModel, CustomError>) -> Void) {
        NetworkService.shared.request(route: route) { result in
            switch result {
            case .success(let data):
                if let postResponse = self.parseJson(data, expacting: PreviewPostListModel.self) {
                    completion(.success(postResponse))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
