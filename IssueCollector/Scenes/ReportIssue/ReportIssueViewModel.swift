//
//  ReportIssueViewModel.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

class ReportIssueViewModel {
    
    lazy var createIssueRequest = CreateIssueRequest()
    let jiraProvider = JiraProvider.shared
    var projectDetails: SubrojectDetailsResponse?
    var priorities: Assignee?
    
    struct DefaultData {
        let projectName: String
        let issueType: String?
        let projectFields: ProjectFields
    }
    
    struct ProjectFields {
        let stepsToReproduce: Customfield100?
        let priorities: Assignee?
    }
    
    // MARK: - Lifecycle
    func checkForDefaultSettings(onCompletion: @escaping (Result<DefaultData?,Error>) -> Void) {
        let defaultManager = DefaultManager()
        if let settings = defaultManager.getDefaultSettings() {
            addProjectID(settings.project.id)
            if let issueType = settings.issueType {
                addIssueTypeID(issueType.id)
            }
            
            getProjectFields(with: settings.project.id) { response in
                switch response {
                case .success(let projectFields):
                    let defaults = DefaultData.init(projectName: settings.project.name,
                                                    issueType: settings.issueType?.name,
                                                    projectFields: projectFields)
                    onCompletion(.success(defaults))
                case .failure(let error):
                    onCompletion(.failure(error))
                }
            }
        } else {
            onCompletion(.success(nil))
        }
    }

    // MARK: - CreateIssueRequest
    func addProjectID(_ id: Int) {
        self.createIssueRequest.fields.project.id = String(id)
    }
    
    func addIssueTypeID(_ id: Int) {
        self.createIssueRequest.fields.issuetype.id = String(id)
    }
    
    func addSummary(_ summary: String) {
        self.createIssueRequest.fields.summary = summary
    }
    
    func addLabels(_ labels: [String]) {
        self.createIssueRequest.fields.labels = labels
    }
    
    func addPriority(_ id: Int) {
        self.createIssueRequest.fields.priority.id = String(id)
    }
    
    func addDescription(_ description: String) {
        self.createIssueRequest.fields.fieldsDescription = .init(type: "doc",
                                                                 version: 1,
                                                                 content: [.init(type: "paragraph",
                                                                                 content: [.init(text: description,
                                                                                                 type: "text")])])
      }
    
    func addStepToReproduce(_ description: String) {
        self.createIssueRequest.fields.fieldsDescription = .init(type: "doc",
                                                                 version: 1,
                                                                 content: [.init(type: "paragraph",
                                                                                 content: [.init(text: description,
                                                                                                 type: "text")])])
      }

    func addEnvironment(_ environment: String) {
        self.createIssueRequest.fields.environment = .init(type: "doc",
                                                           version: 1,
                                                           content: [.init(type: "paragraph",
                                                                           content: [.init(text: environment,
                                                                                           type: "text")])])
    }
    
    // MARK: - Api calls
    func createIssue(onCompletion: @escaping (Result<Void, Error>) -> Void) {
        jiraProvider.createIssue(with: createIssueRequest) { response in
            switch response {
            case .success(let issueResponse):
                self.addAttachment(issueID: Int(issueResponse.id)!) { attachmentResponse in
                    switch attachmentResponse {
                    case .success:
                        onCompletion(.success(()))

                    case .failure(let error):
                        onCompletion(.failure(error))
                    }
                }
                
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    
    func getProjectDetails(with id: Int, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        jiraProvider.getProjectDetails(with: id) { response in
            switch response {
            case .success(let projectDetails):
                self.projectDetails = projectDetails
                onCompletion(.success(()))
                
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    
    func getProjectFields(with id: Int, onCompletion: @escaping (Result<ProjectFields, Error>) -> Void) {
        jiraProvider.getProjectFields(with: id) { [weak self] response in
            switch response {
            case .success(let projectDesc):
                let fields = projectDesc
                    .projects.first?
                    .issuetypes.first(where: { $0.name == "Bug" })?.fields
                let stepsToReprodce = fields?.customfield10062
                let priorities = fields?.priority
                self?.priorities = priorities
                onCompletion(.success(ProjectFields.init(stepsToReproduce: stepsToReprodce,
                                                         priorities: priorities)))
                
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
    
    func addAttachment(issueID: Int, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        jiraProvider.addAttachment(to: issueID) { response in
            switch response {
            case .success:
                onCompletion(.success(()))
                
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}

