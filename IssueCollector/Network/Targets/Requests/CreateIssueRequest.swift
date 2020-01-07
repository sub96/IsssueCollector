//
//  CreateIssueRequest.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

// MARK: - CreateProjectRequest
struct CreateIssueRequest: Codable {
    let update: Update
    var fields: Fields
    
    init() {
        self.update = Update.init()
        self.fields = Fields.init(summary: "nil",
                                  issuetype: .init(id: "nil"),
                                  project: .init(id: "nil"),
                                  fieldsDescription: .init(type: "doc",
                                                           version: 1,
                                                           content: [DescriptionContent.init(type: "paragraph",
                                                                                             content: [ContentContent.init(text: "nil",
                                                                                                                           type: "text")])]),
                                  labels: ["nil"],
                                  environment: .init(type: "doc",
                                                     version: 1,
                                                     content: [DescriptionContent.init(type: "paragraph",
                                                                                       content: [ContentContent.init(text: "nil",
                                                                                                                     type: "text")])]))
    }
}

// MARK: - Fields
struct Fields: Codable {
    var summary: String
    var issuetype, project: Issuetype
    var fieldsDescription: Description
    var labels: [String]
    var environment: Description

    enum CodingKeys: String, CodingKey {
        case summary, issuetype, project
        case fieldsDescription = "description"
        case labels, environment
    }
}

// MARK: - Description
struct Description: Codable {
    let type: String
    let version: Int
    let content: [DescriptionContent]
}

// MARK: - DescriptionContent
struct DescriptionContent: Codable {
    let type: String
    let content: [ContentContent]
}

// MARK: - ContentContent
struct ContentContent: Codable {
    let text, type: String
}

// MARK: - Issuetype
struct Issuetype: Codable {
    var id: String
}

// MARK: - Update
struct Update: Codable {
}

//extension CreateIssueRequest {
//    func asJson() -> Data {
//        do {
//            return try JSONEncoder().encode(self)
//
//        } catch {
//            print("Error")
//            return Data()
//        }
//    }
//}
