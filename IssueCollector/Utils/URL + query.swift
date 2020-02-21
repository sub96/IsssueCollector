//
//  URL + query.swift
//  IssueCollector
//
//  Created by Suhaib on 06/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

extension URL {
    public var queryParameters: [URLQueryItem] {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return [] }
        return queryItems
    }
}
