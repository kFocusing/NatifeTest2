//
//  NetworkService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func request(route: String, completion: @escaping (_ result: RequestResult) -> Void)
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
                 completion: @escaping (_ result: RequestResult) -> Void) {
        
        let fullURLString = baseURL + route
        guard let url = URL(string: fullURLString) else {
            completion(.failure(error: CustomError(message: "Invalid route")))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                completion(.failure(error: CustomError(message: "Couldn't get data from the server")))
                return
            }
            completion(.success(data: data))
        }.resume()
    }
}

struct CustomError {
    var code: Int?
    var message: String?
}
