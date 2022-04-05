//
//  PostsService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 05.04.2022.
//

import Foundation

protocol PostsServiceProtocol {
    func fetchPost<T: Codable>(route: String,
                               expacting: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void)
}

class PostsService: PostsServiceProtocol {
    
    //MARK: - Internal -
    func fetchPost<T: Codable>(route: String,
                               expacting: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        NetworkService.shared.request(route: route) { result in
            switch result {
            case .success(let data):
                if let postResponse = self.parseJson(data, expacting: expacting) {
                    completion(.success(postResponse))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //MARK: - Private -
    private func parseJson<T: Codable>(_ data: Data, expacting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expacting, from: data)
            return decodateData
        } catch {
            return nil
        }
    }
}
