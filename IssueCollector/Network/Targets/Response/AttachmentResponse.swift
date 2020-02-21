//
//  AttachmentResponse.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

// MARK: - AttachmentResponseElement
struct AttachmentResponseElement: Codable {
    let attachmentResponseSelf: String
    let id, filename: String
    let author: Author
    let created: String
    let size: Int
    let mimeType: String
    let content: String
    let thumbnail: String?

    enum CodingKeys: String, CodingKey {
        case attachmentResponseSelf = "self"
        case id, filename, author, created, size, mimeType, content, thumbnail
    }
}

// MARK: - Author
struct Author: Codable {
    let authorSelf: String
    let name, key, accountID, emailAddress: String
    let avatarUrls: AvatarUrls
    let displayName: String
    let active: Bool
    let timeZone, accountType: String

    enum CodingKeys: String, CodingKey {
        case authorSelf = "self"
        case name, key
        case accountID = "accountId"
        case emailAddress, avatarUrls, displayName, active, timeZone, accountType
    }
}

typealias AttachmentResponse = [AttachmentResponseElement]
