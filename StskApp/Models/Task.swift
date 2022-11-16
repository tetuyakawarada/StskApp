//
//  Task.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/16.
//

import Foundation

struct Task: Codable {
    let id: Int
    let title: String
    let body: String
//    let createdAt: String
//    let userName: String
//    let imageUrl: String
//    let comments: [Comment]?
    
    enum CodingKeys:  String, CodingKey {
        case id
        case title
        case body
//        case createdAt = "created_at"
//        case userName = "user_name"
//        case imageUrl = "image_url"
//        case comments
    }
}

