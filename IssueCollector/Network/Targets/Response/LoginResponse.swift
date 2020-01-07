//
//  LoginResponse.swift
//  IssueCollector
//
//  Created by Suhaib on 06/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let accessToken, scope: String
    let refreshToken: String?
    let expiresIn: Int
    let tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case scope
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
