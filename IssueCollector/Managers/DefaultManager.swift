//
//  DefaultManager.swift
//  IssueCollector
//
//  Created by Suhaib on 03/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

class DefaultManager {
    private enum DefaultKeys {
        enum Login: String {
            case accessToken
        }
        
        enum Settings: String {
            case settingsConfigured
            case appName
        }
        
        enum Project: String {
            case projectName
            case projectImageUrl
            case projectId
        }
        
        enum IssueType: String {
            case issueTypeName
            case issueTypeImageUrl
            case issueTypeId
        }
    }
    
    var accessToken: String? {
        get { return defaults.string(forKey: DefaultKeys.Login.accessToken.rawValue) }
        set { defaults.set(newValue, forKey: DefaultKeys.Login.accessToken.rawValue) }
    }
    
    var isNotFirstLaunch: Bool {
        get { return defaults.bool(forKey: DefaultKeys.Settings.settingsConfigured.rawValue) }
        set { defaults.set(newValue, forKey: DefaultKeys.Settings.settingsConfigured.rawValue) }
    }
    
    var defaultProject: PickerElement? {
        get {
            guard let projectName = defaults.string(forKey: DefaultKeys.Project.projectName.rawValue),
                let projectImageUrl = defaults.url(forKey: DefaultKeys.Project.projectImageUrl.rawValue)
                else { return nil }
            let projectID = defaults.integer(forKey: DefaultKeys.Project.projectId.rawValue)
            return PickerElement(name: projectName, url: projectImageUrl, id: projectID)
        }
        set {
            defaults.set(newValue?.name, forKey: DefaultKeys.Project.projectName.rawValue)
            defaults.set(newValue?.url, forKey: DefaultKeys.Project.projectImageUrl.rawValue)
            defaults.set(newValue?.id, forKey: DefaultKeys.Project.projectId.rawValue)
        }
    }
    
    var defaultIssueType: PickerElement? {
        get {
            guard let projectName = defaults.string(forKey: DefaultKeys.IssueType.issueTypeName.rawValue),
                let projectImageUrl = defaults.url(forKey: DefaultKeys.IssueType.issueTypeImageUrl.rawValue)
                else { return nil }
            let projectID = defaults.integer(forKey: DefaultKeys.IssueType.issueTypeId.rawValue)
            return PickerElement(name: projectName, url: projectImageUrl, id: projectID)
        }
        set {
            defaults.set(newValue?.name, forKey: DefaultKeys.IssueType.issueTypeName.rawValue)
            defaults.set(newValue?.url, forKey: DefaultKeys.IssueType.issueTypeImageUrl.rawValue)
            defaults.set(newValue?.id, forKey: DefaultKeys.IssueType.issueTypeId.rawValue)
        }
    }
    
    var appName: String? {
        get { return defaults.string(forKey: DefaultKeys.Settings.appName.rawValue) }
        set { defaults.set(newValue, forKey: DefaultKeys.Settings.appName.rawValue) }
    }
    
    let defaults = UserDefaults.standard
    
    func getDefaultSettings() -> (project: PickerElement, issueType: PickerElement?)?{
        if let defaultProject = defaultProject {
            if let defaultIssueType = defaultIssueType {
                return (project: defaultProject, issueType: defaultIssueType)
            }
            return (project: defaultProject, issueType: nil)
        } else {
            return nil
        }
        
    }
}
