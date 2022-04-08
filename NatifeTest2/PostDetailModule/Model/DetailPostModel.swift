//
//  DetailPostModel.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 04.04.2022.
//

import Foundation

struct DetailPostModelRequest: Codable {
    let post: DetailPostModel
}

struct DetailPostModel: Codable {
    let postID, timeshamp: Int
    let title, text: String
    let images: [String]
    let likesCount: Int

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title, text, images
        case likesCount = "likes_count"
    }
}

