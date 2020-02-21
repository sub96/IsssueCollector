//
//  UserResponse.swift
//  IssueCollector
//
//  Created by Suhaib on 07/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

struct UserResponse: Codable {
    let accountType, accountID, email, name: String
    let picture: URL
    let accountStatus, nickname, zoneinfo, locale: String
    let extendedProfile: ExtendedProfile
    let emailVerified: Bool

    enum CodingKeys: String, CodingKey {
        case accountType = "account_type"
        case accountID = "account_id"
        case email, name, picture
        case accountStatus = "account_status"
        case nickname, zoneinfo, locale
        case extendedProfile = "extended_profile"
        case emailVerified = "email_verified"
    }
}

// MARK: - ExtendedProfile
struct ExtendedProfile: Codable {
    let jobTitle: String

    enum CodingKeys: String, CodingKey {
        case jobTitle = "job_title"
    }
}
