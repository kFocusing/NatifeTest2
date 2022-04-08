//
//  BaseService.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 07.04.2022.
//

import Foundation

class BaseService {
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
