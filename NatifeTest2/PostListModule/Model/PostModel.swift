//
//  PostModel.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

struct PostListModel: Codable {
    let posts: [PostModel]
}

struct PostModel: Codable {
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

