//
//  JiraProvider.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation
import Moya

class JiraProvider {
    enum CustomError: Error {
        case generic(String)
    }
    
    static var shared = JiraProvider()
    var projects: SubrojectResponse = []
    var currentUser: UserResponse?
    var capturedFile: Previewtype?
    
    private var provider: MoyaProvider<ProjectTarget> = {
        return MoyaProvider<ProjectTarget>.init()
    }()
    
    func login(with code: String, onCompletion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let request = LoginRequest.init(code: code)
        provider.request(ProjectTarget.login(request: request)) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(LoginResponse.self)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func getAccesssToken(with refreshToken: String, onCompletion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let request = AccessTokenRequest.init(refresh_token: refreshToken)
        provider.request(.getAccessToken(request: request)) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(LoginResponse.self)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func getCurrentUser(onCompletion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.getCurrentUser) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(UserResponse.self)
                self.currentUser = response
                onCompletion(.success(()))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func getProjects(onCompletion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(ProjectTarget.getProjects) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(SubrojectResponse.self)
                self.projects = response
                onCompletion(.success(()))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func getProjectDetails(with id: Int, onCompletion: @escaping (Result<SubrojectDetailsResponse, Error>) -> Void) {
        provider.request(ProjectTarget.getProjectDetails(id: id)) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(SubrojectDetailsResponse.self)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func createIssue(with request: CreateIssueRequest, onCompletion: @escaping (Result<CreateIssueResponse, Error>) -> Void) {
        provider.request(ProjectTarget.createIssue(request: request)) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(CreateIssueResponse.self)
                onCompletion(.success(response))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
    
    func addAttachment(to projectID: Int, onCompletion: @escaping (Result<Void, Error>) -> Void) {
        let data: Data? = {
            switch self.capturedFile {
            case .image(let image):
                return image.jpegData(compressionQuality: 1)
                
            case .video(let url):
                return try? Data.init(contentsOf: url)
                
            case .none:
                return nil
            }
        }()
        
        guard let attachment = data else {
            onCompletion(.failure(CustomError.generic("Failed to create data")))
            return 
        }
        
        provider.request(ProjectTarget.addAttachment(data: attachment, projectID: projectID)) { result in
            do {
                _ = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(AttachmentResponse.self)
                onCompletion(.success(()))
            } catch {
                onCompletion(.failure(error))
            }
        }
    }
}
