////
////  FieldsResponse.swift
////  IssueCollector
////
////  Created by DTT Multimedia on 13/01/2020.
////  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
////
//
import Foundation

// MARK: - FieldsResponse
struct FieldsResponse: Codable {
    let expand: String
    let projects: [Project]
}

// MARK: - Project
struct Project: Codable {
    let expand: String
    let projectSelf: URL
    let id, key, name: String
    let avatarUrls: AvatarUrls
    let issuetypes: [FieldIssuetype]

    enum CodingKeys: String, CodingKey {
        case expand
        case projectSelf = "self"
        case id, key, name, avatarUrls, issuetypes
    }
}

// MARK: - Issuetype
struct FieldIssuetype: Codable {
    let issuetypeSelf: URL
    let id, issuetypeDescription: String
    let iconURL: URL
    let name: String
    let subtask: Bool
    let expand: String?
    let fields: Fields?
    let avatarID: Int?

    enum CodingKeys: String, CodingKey {
        case issuetypeSelf = "self"
        case id
        case issuetypeDescription = "description"
        case iconURL = "iconUrl"
        case name, subtask, expand, fields
        case avatarID = "avatarId"
    }
}

extension Project {
    func asIssueType() -> [PickerElement] {
        
        return self.issuetypes.map { (name: $0.name,
                                      url: $0.iconURL,
                                      id: Int($0.id)!) }
    }
}

// MARK: - Fields
struct Fields: Codable {
    let summary, issuetype: Assignee
    let components: Attachment
    let fieldsDescription, project: Assignee
    let customfield10021, customfield10065: Customfield100?
    let fixVersions: Attachment
    let customfield10066: Customfield100?
    let priority: Assignee
    let customfield10067, customfield10068, customfield10014, customfield10069: Customfield100?
    let labels, attachment, issuelinks: Attachment
    let assignee: Assignee
    let parent: Assignee?
    let customfield10061, customfield10062, customfield10063: Customfield100?
    let environment: Assignee?
    let versions: Attachment?
    let customfield10011: Customfield100?

    enum CodingKeys: String, CodingKey {
        case summary, issuetype, components
        case fieldsDescription = "description"
        case project
        case customfield10021 = "customfield_10021"
        case customfield10065 = "customfield_10065"
        case fixVersions
        case customfield10066 = "customfield_10066"
        case priority
        case customfield10067 = "customfield_10067"
        case customfield10068 = "customfield_10068"
        case customfield10014 = "customfield_10014"
        case customfield10069 = "customfield_10069"
        case labels, attachment, issuelinks, assignee, parent
        case customfield10061 = "customfield_10061"
        case customfield10062 = "customfield_10062"
        case customfield10063 = "customfield_10063"
        case environment, versions
        case customfield10011 = "customfield_10011"
    }
}

// MARK: - Assignee
struct Assignee: Codable {
    let assigneeRequired: Bool
    let schema: AssigneeSchema
    let name, key: String
	let hasDefaultValue: Bool
    let autoCompleteURL: String?
    let operations: [Operation]
    let allowedValues: [AllowedValue]?
    let defaultValue: DefaultValue?

    enum CodingKeys: String, CodingKey {
        case assigneeRequired = "required"
        case schema, name, key
        case autoCompleteURL = "autoCompleteUrl"
        case hasDefaultValue, operations, allowedValues, defaultValue
    }
}

extension Assignee {
    func asPriorities() -> [PickerElement] {
        
        guard let values = self.allowedValues else { return [] }
        return values.map { (name: $0.name,
                             url: $0.iconURL ?? URL.init(string: "google.com")!,
                             id: Int($0.id)!) }
    }
}


// MARK: - AllowedValue
struct AllowedValue: Codable {
    let allowedValueSelf: URL
    let id: String
    let allowedValueDescription: String?
    let iconURL: URL?
    let name: String
    let subtask: Bool?
    let avatarID: Int?
    let key, projectTypeKey: String?
    let simplified: Bool?
    let avatarUrls: AvatarUrls?
    let projectCategory: DefaultValue?

    enum CodingKeys: String, CodingKey {
        case allowedValueSelf = "self"
        case id
        case allowedValueDescription = "description"
        case iconURL = "iconUrl"
        case name, subtask
        case avatarID = "avatarId"
        case key, projectTypeKey, simplified, avatarUrls, projectCategory
    }
}

// MARK: - DefaultValue
struct DefaultValue: Codable {
    let defaultValueSelf: String
    let id, name: String
    let iconURL: String?
    let defaultValueDescription: String?

    enum CodingKeys: String, CodingKey {
        case defaultValueSelf = "self"
        case id, name
        case iconURL = "iconUrl"
        case defaultValueDescription = "description"
    }
}

enum Operation: String, Codable {
    case add = "add"
    case operationSet = "set"
    case remove = "remove"
}

// MARK: - AssigneeSchema
struct AssigneeSchema: Codable {
    let type, system: String
}

// MARK: - Attachment
struct Attachment: Codable {
    let attachmentRequired: Bool
    let schema: AttachmentSchema
    let name, key: String
    let hasDefaultValue: Bool
    let operations: [Operation]
    let allowedValues: [DefaultValue]?
    let autoCompleteURL: String?

    enum CodingKeys: String, CodingKey {
        case attachmentRequired = "required"
        case schema, name, key, hasDefaultValue, operations, allowedValues
        case autoCompleteURL = "autoCompleteUrl"
    }
}

// MARK: - AttachmentSchema
struct AttachmentSchema: Codable {
    let type: TypeEnum
    let items: Items
    let system: String
}

enum Items: String, Codable {
    case attachment = "attachment"
    case component = "component"
    case issuelinks = "issuelinks"
    case string = "string"
    case version = "version"
}

enum TypeEnum: String, Codable {
    case any = "any"
    case array = "array"
    case number = "number"
    case string = "string"
}

// MARK: - Customfield100
struct Customfield100: Codable {
    let customfield100_Required: Bool
    let schema: PurpleSchema
    let name, key: String
    let hasDefaultValue: Bool
    let operations: [Operation]

    enum CodingKeys: String, CodingKey {
        case customfield100_Required = "required"
        case schema, name, key, hasDefaultValue, operations
    }
}

// MARK: - PurpleSchema
struct PurpleSchema: Codable {
    let type: TypeEnum
    let custom: Custom
    let customID: Int
    let items: Items?

    enum CodingKeys: String, CodingKey {
        case type, custom
        case customID = "customId"
        case items
    }
}

enum Custom: String, Codable {
    case comAtlassianJiraPluginSystemCustomfieldtypesFloat = "com.atlassian.jira.plugin.system.customfieldtypes:float"
    case comAtlassianJiraPluginSystemCustomfieldtypesTextarea = "com.atlassian.jira.plugin.system.customfieldtypes:textarea"
    case comAtlassianJiraPluginSystemCustomfieldtypesTextfield = "com.atlassian.jira.plugin.system.customfieldtypes:textfield"
    case comPyxisGreenhopperJiraGhEpicLabel = "com.pyxis.greenhopper.jira:gh-epic-label"
    case comPyxisGreenhopperJiraGhEpicLink = "com.pyxis.greenhopper.jira:gh-epic-link"
    case comPyxisGreenhopperJiraGhSprint = "com.pyxis.greenhopper.jira:gh-sprint"
}
