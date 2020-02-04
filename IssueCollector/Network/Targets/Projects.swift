//
//  Projects.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import Foundation
import Moya
import Alamofire

enum ProjectTarget: TargetType {
        
    case login(request: LoginRequest)
    case getAccessToken(request: AccessTokenRequest)
    case getCurrentUser
    
    case getProjects
    case getProject(key: String)
    case getProjectDetails(id: Int)
	case getProjectFields(id: Int)
    
    case getFields
    case createIssue(request: CreateIssueRequest)
    case addAttachment(data: Data, projectID: Int)
    
    var accessToken: String {
        return String.init(data: KeyChain().load(key: KeyChain.Key.accessToken.rawValue) ?? Data(),
                           encoding: .utf8)  ?? ""
    }
    
    var baseURL: URL {
        
        switch self {
        case .login,
             .getAccessToken:
            return URL.init(string: "https://auth.atlassian.com/oauth/token")!
            
        case .getCurrentUser:
            return URL.init(string: "https://api.atlassian.com/me")!
            
        default:
            return URL.init(string: "https://dtt-dev.atlassian.net/rest/api/3")!
        }
    }
    
    var path: String {
        switch self {
         case .getProjects:
             return "project"
        case .getProject(let projectKey):
            return "project/\(projectKey)"
         case .getProjectDetails(let id):
             return "project/\(id)"
		case .getProjectFields:
			return "issue/createmeta"
         case .createIssue:
             return "issue"
         case .addAttachment(data: _, projectID: let id):
             return "issue/\(id)/attachments"
        case .getFields:
            return "field"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getProjects,
             .getProject,
             .getProjectDetails,
			 .getProjectFields,
             .getCurrentUser,
             .getFields:
            return .get
        case .createIssue,
             .addAttachment,
             .login,
             .getAccessToken:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getProjects,
             .getProject,
             .getProjectDetails,
             .getCurrentUser,
             .getFields:
            return .requestPlain
            
		case .getProjectFields(let id):
			return .requestParameters(parameters: ["projectIds" : id,
												   "expand": "projects.issuetypes.fields"],
									  encoding: URLEncoding.default)
			
        case .createIssue(let request):
            return .requestJSONEncodable(request)
            
        case .addAttachment(let data, _):
            let data = MultipartFormData.init(provider: .data(data),
                                              name: "file",
                                              fileName: "file",
                                              mimeType: "image/jpeg")
            return .uploadMultipart([data])
            
        case .login(request: let request):
            return .requestJSONEncodable(request)
            
        case .getAccessToken(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCurrentUser:
            return ["Authorization": "Bearer \(accessToken)",
                "Accept": "application/json"]
            
        case .getAccessToken:
            return ["Content-Type": "application/json"]
            
        case .addAttachment:
            return ["Content-Type": "multipart/form-data",
                    "X-Atlassian-Token": "no-check",
                    "Authorization": "Bearer \(accessToken)"]

        default:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(accessToken)"]
        }
    }
}
