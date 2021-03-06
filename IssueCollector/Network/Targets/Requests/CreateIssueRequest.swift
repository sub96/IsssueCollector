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
	var fields: CreateIssueFields
	
	init() {
		self.update = Update.init()
		self.fields = CreateIssueFields.init(summary: "nil",
											 issuetype: .init(id: "nil"),
											 project: .init(id: "nil"),
											 fieldsDescription: .init(type: "doc",
																	  version: 1,
																	  content: [DescriptionContent.init(type: "paragraph",
																										content: [ContentContent.init(text: "nil",
																																	  type: "text")])]),
											 labels: nil,
											 environment: nil,
                                             stepsToReproduce: nil,
                                             priority: .init(id: "1")
		)
	}
}

// MARK: - Fields
struct CreateIssueFields: Codable {
	var summary: String
	var issuetype, project: CreateIssuetype
	var fieldsDescription: Description
	var labels: [String]?
	var environment: Description?
	var stepsToReproduce: Description?
    var priority: CreateIssuetype
	
	enum CodingKeys: String, CodingKey {
		case summary, issuetype, project, priority
		case fieldsDescription = "description"
		case labels, environment
		case stepsToReproduce = "customfield_10062"
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
struct CreateIssuetype: Codable {
	var id: String
}

// MARK: - Update
struct Update: Codable {
}
