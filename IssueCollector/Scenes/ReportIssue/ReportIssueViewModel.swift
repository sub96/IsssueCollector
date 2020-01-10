//
//  ReportIssueViewModel.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

class ReportIssueViewModel {
    
    let jiraProvider = JiraProvider.shared
    var projectDetails: SubrojectDetailsResponse?
    var createIssueRequest = CreateIssueRequest()
    
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

