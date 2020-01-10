//
//  DetailsViewModel.swift
//  IssueCollector
//
//  Created by Suhaib on 07/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation


class DetailsViewModel {
    let keychain = KeyChain.init()
    let jiraProvider = JiraProvider.shared
    
    /// Decide the start flow
    /// - Parameter completion:
    ///   - true: User already logged in
    ///   - false: User never logged in
    ///   - error: error occured
    func startInitialFlow(completion: @escaping (Result<Bool, Error>) -> Void) {
        
        /// Fetch current user and projects
        func makeInitialCalls() {
            self.getCurrentUser { userResponse in
                switch userResponse {
                case .success:
                    self.getProjects { projectResponse in
                        switch projectResponse {
                        case .success:
                            self.jiraProvider.getFields()
                            completion(.success(true))
                            
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
        if let refreshToken = keychain.getRefreshToken() {
            jiraProvider.getAccesssToken(with: refreshToken) { [weak self] response in
                switch response {
                case .success(let result):
                    self?.keychain.save(accessToken: result.accessToken,
                                        refreshToken: nil)
                    makeInitialCalls()
     
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(false))
        }
    }
    
    func getProjects(completion: @escaping (Result<Void, Error>) -> Void) {
        jiraProvider.getProjects { response in
            switch response {
            case .success:
                print("Project fetched")
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCurrentUser(completion: @escaping (Result<Void, Error>) -> Void) {
        jiraProvider.getCurrentUser { response in
            switch response {
            case .success:
                print("User fetched")
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
