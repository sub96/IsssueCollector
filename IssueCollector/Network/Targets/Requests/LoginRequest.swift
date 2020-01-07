//
//  LoginRequest.swift
//  IssueCollector
//
//  Created by Suhaib on 06/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let grant_type = "authorization_code"
    let client_id = "gUVPhVEvA21QYAREKVyT17ybPcwPqoJv"
    let client_secret = "-6xeTsHcU2S-0-xUaRyizo-AmL0noGiYkRd-2336DTHDF9ejcRp9dBSU_cBZNnpF"
    let redirect_uri = "https://www.google.com"
    
    let code: String
}

struct AccessTokenRequest: Codable {
    let grant_type = "refresh_token"
    let client_id = "gUVPhVEvA21QYAREKVyT17ybPcwPqoJv"
    let client_secret = "-6xeTsHcU2S-0-xUaRyizo-AmL0noGiYkRd-2336DTHDF9ejcRp9dBSU_cBZNnpF"
    
    let refresh_token: String
}
