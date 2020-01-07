//
//  ProjectDetails.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

struct SubrojectDetailsResponse: Codable {
    let expand: String
    let subrojectResponseSelf: URL
    let id, key, subrojectResponseDescription: String
    let lead: Lead
    let components: [ProjectCategory]
    let issueTypes: [IssueType]
    let assigneeType: String
    let versions: [Version]
    let name: String
    let roles: Roles
    let avatarUrls: AvatarUrls
    let projectCategory: ProjectCategory
    let projectTypeKey: String
    let simplified: Bool
    let style: String
    let isPrivate: Bool
    let properties: Properties

    enum CodingKeys: String, CodingKey {
        case expand
        case subrojectResponseSelf = "self"
        case id, key
        case subrojectResponseDescription = "description"
        case lead, components, issueTypes, assigneeType, versions, name, roles, avatarUrls, projectCategory, projectTypeKey, simplified, style, isPrivate, properties
    }
}


// MARK: - IssueType
struct IssueType: Codable {
    let issueTypeSelf: String
    let id, issueTypeDescription: String
    let iconURL: URL
    let name: String
    let subtask: Bool
    let avatarID: Int?

    enum CodingKeys: String, CodingKey {
        case issueTypeSelf = "self"
        case id
        case issueTypeDescription = "description"
        case iconURL = "iconUrl"
        case name, subtask
        case avatarID = "avatarId"
    }
}

struct Version: Codable {
    let versionSelf: String
    let id, versionDescription, name: String
    let archived, released: Bool
    let startDate, releaseDate: String
    let overdue: Bool?
    let userStartDate, userReleaseDate: String
    let projectID: Int

    enum CodingKeys: String, CodingKey {
        case versionSelf = "self"
        case id
        case versionDescription = "description"
        case name, archived, released, startDate, releaseDate, overdue, userStartDate, userReleaseDate
        case projectID = "projectId"
    }
}

// MARK: - Lead
struct Lead: Codable {
    let leadSelf: String
    let key, accountID, name: String
    let avatarUrls: AvatarUrls
    let displayName: String
    let active: Bool

    enum CodingKeys: String, CodingKey {
        case leadSelf = "self"
        case key
        case accountID = "accountId"
        case name, avatarUrls, displayName, active
    }
}

// MARK: - Roles
struct Roles: Codable {
    let atlassianAddonsProjectAccess, softwareDeveloper, developers, administrators: String
    let client, softwareDeveloperIntern: String

    enum CodingKeys: String, CodingKey {
        case atlassianAddonsProjectAccess = "atlassian-addons-project-access"
        case softwareDeveloper = "Software Developer"
        case developers = "Developers"
        case administrators = "Administrators"
        case client = "Client"
        case softwareDeveloperIntern = "Software Developer (intern)"
    }
}

extension SubrojectDetailsResponse {
    func asIssueType() -> [PickerElement] {
        return self.issueTypes.map { (name: $0.name,
                                      url: $0.iconURL,
                                      id: Int($0.id)!) }
    }
}
