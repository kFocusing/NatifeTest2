//
//  NetworkService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func getData<T: Codable>(url: URL, expacting: T.Type, completion: @escaping (Result<T, Error>) -> Void) 
}

class NetworkService: NetworkServiceProtocol {
    
    //MARK: - Internal -
    func getData<T: Codable>(url: URL, expacting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let session = URLSession(configuration: .default)
        
           session.dataTask(with: url) { (data, _, error) in
               guard let data = data, error == nil else {
                   completion(.failure(NetworkingError.failedResponseJSON))
                   return
               }
               if let post = self.parseJson(data, expacting: expacting) {
                   completion(.success(post))
               } else {
                   completion(.failure(NetworkingError.failedParseJSON))
               }
           }.resume()
       }
    
    func getDataRequestAPI<T: Codable>(url: URL,
                                       expacting: T.Type,
                                       completion: @escaping (Result<T, Error>) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let post = self.parseJson(data, expacting: expacting) {
                    completion(.success(post))
                } else {
                    completion(.failure(NetworkingError.failedParseJSON))
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
        
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
       
       private enum NetworkingError: Error {
           case failedResponseJSON
           case failedParseJSON
       }
}
