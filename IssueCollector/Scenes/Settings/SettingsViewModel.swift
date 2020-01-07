//
//  SettingsViewModel.swift
//  IssueCollector
//
//  Created by Suhaib on 24/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import Foundation
import Moya

class SettingsViewModel {
    
    enum UserErrors: Error {
        case noUserFound
    }
    
    let jiraProvider = JiraProvider.shared
    
    var currentUser: UserResponse?
    var projects: SubrojectResponse = []
    var projectDetails: SubrojectDetailsResponse?
    
    var selectedProject: PickerElement?
    var selectedIssueType: PickerElement?
    
    func configureProjects() {
        self.projects = self.jiraProvider.projects
    }
    
    func configureCurrentUser(onCompletion: @escaping (Result<UserResponse, Error>) -> Void) {
        guard let currentUser = self.jiraProvider.currentUser else {
            onCompletion(.failure(UserErrors.noUserFound))
            return
        }
        
        self.currentUser = currentUser
        onCompletion(.success(currentUser))
    }
    
    func getProjectDetails(onCompletion: @escaping (Result<Void, Error>) -> Void) {
        guard let selectedProject = selectedProject else { return }
        jiraProvider.getProjectDetails(with: selectedProject.id) { response in
            switch response {
            case .success(let projectDetails):
                self.projectDetails = projectDetails
                onCompletion(.success(()))
                
            case .failure(let error):
                onCompletion(.failure(error))
            }
        }
    }
}

