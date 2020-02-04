//
//  ProjectsResponse.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import Foundation

// MARK: - SubrojectResponseElement
struct SubrojectResponseElement: Codable {
    let expand: String
    let subrojectResponseSelf: String
    let id, key, name: String
    let avatarUrls: AvatarUrls
    let projectTypeKey: String
    let simplified: Bool
    let style: String
    let isPrivate: Bool
    let properties: Properties
    let projectCategory: ProjectCategory?
    let entityID, uuid: String?

    enum CodingKeys: String, CodingKey {
        case expand
        case subrojectResponseSelf = "self"
        case id, key, name, avatarUrls, projectTypeKey, simplified, style, isPrivate, properties, projectCategory
        case entityID = "entityId"
        case uuid
    }
}

// MARK: - AvatarUrls
struct AvatarUrls: Codable {
    let the48X48, the24X24, the16X16, the32X32: URL

    enum CodingKeys: String, CodingKey {
        case the48X48 = "48x48"
        case the24X24 = "24x24"
        case the16X16 = "16x16"
        case the32X32 = "32x32"
    }
}

// MARK: - ProjectCategory
struct ProjectCategory: Codable {
    let projectCategorySelf: String
    let id, name: String
    let isAssigneeTypeValid: Bool?
    let projectCategoryDescription: String?

    enum CodingKeys: String, CodingKey {
        case projectCategorySelf = "self"
        case id, name, isAssigneeTypeValid
        case projectCategoryDescription = "description"
    }
}

enum Name: String, Codable {
    case android = "Android"
    case client = "Client"
    case design = "Design"
    case dev = "Dev"
    case iOS = "iOS"
    case qa = "QA"
    case sales = "Sales"
    case unity = "Unity"
    case web = "Web"
}



// MARK: - Properties
struct Properties: Codable {
}

typealias SubrojectResponse = [SubrojectResponseElement]

extension SubrojectResponse {
    func asProject() -> [PickerElement] {
        let data = self.map { (name: $0.name,
                               url: $0.avatarUrls.the48X48,
                               id: Int($0.id)!) }
        return data.filter({ element in
            return element.name.contains("Dev") || element.name.contains("QA")
        })
    }
}

extension SubrojectResponseElement {
    func asProject() -> PickerElement {
        return (name: self.name,
                url: self.avatarUrls.the48X48,
                id: Int(self.id)!)
    }
}
