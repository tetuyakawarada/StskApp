//
//  GetToken.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/14.
//

import Foundation

struct GetToken: Codable {
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
