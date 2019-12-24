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
    
    private var provider: MoyaProvider<ProjectTarget> = {
        return MoyaProvider<ProjectTarget>.init(plugins: [AccessTokenPlugin.init(tokenClosure: { () -> String in
            guard let loginData = String(format: "\("saghir@d-tt.nl"):\("KR8x2M6urnyOA7KH4Cum1693")")
                .data(using: .utf8) else { return "" }
            return loginData.base64EncodedString()
        })])
    }()
    
    func viewDidLoad() {}
    
    func getProjects(onCompletion: @escaping (SubrojectResponse) -> Void) {
        provider.request(ProjectTarget.getProjects) { result in
            do {
                let response = try result
                    .get()
                    .filterSuccessfulStatusCodes()
                    .map(SubrojectResponse.self)
                onCompletion(response)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

