//
//  PostModel.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

struct PreviewPostListModel: Codable {
    let posts: [PreviewPostModel]
}

struct PreviewPostModel: Codable {
    let postID, timeshamp: Int
    let title, previewText: String
    let likesCount: Int
    var isExpended = false

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case timeshamp, title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}



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

