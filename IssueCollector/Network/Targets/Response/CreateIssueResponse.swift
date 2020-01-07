//
//  CreateIssueResponse.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

struct CreateIssueResponse: Codable {
    let id, key: String
    let createProjectRequestSelf: String

    enum CodingKeys: String, CodingKey {
        case id, key
        case createProjectRequestSelf = "self"
    }
}
