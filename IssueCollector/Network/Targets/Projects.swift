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

enum ProjectTarget: TargetType, AccessTokenAuthorizable {
    
    case getProjects
    
    var baseURL: URL {
        let base = URL.init(string: "https://dtt-dev.atlassian.net/rest/api/3")!
        
        switch self {
        case .getProjects:
            return base.appendingPathComponent("project")
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .getProjects:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getProjects:
            return .requestPlain
        }
    }
    
    var authorizationType: AuthorizationType {
        return .basic
    }

    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
