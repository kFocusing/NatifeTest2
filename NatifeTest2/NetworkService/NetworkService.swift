//
//  NetworkService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

typealias completion = (_ result: RequestResult) -> Void

protocol NetworkServiceProtocol {
    func request(route: String, completion: @escaping completion)
}

enum RequestResult {
    case success(data: Data)
    case failure(error: CustomError)
}

class NetworkService: NetworkServiceProtocol {
    
    private let baseURL = "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/"
    
    static let shared = NetworkService()
    
    private init() {}
    
    func request(route: String,
                 completion: @escaping completion) {
        
        let fullURLString = baseURL + route
        guard let url = URL(string: fullURLString) else {
            completion(.failure(error: CustomError(message: "Invalid route")))
            return
        }
        
        let urlRequest = URLRequest(url: url)
       
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(error: CustomError(message: "Invalid route")))
                return
            }
            completion(.success(data: data))
        }.resume()
    }
}

struct CustomError: Error {
    var code: Int?
    var message: String?
}
