//
//  AppDelegate.swift
//  IssueCollectorExampleiOS12
//
//  Created by DTT Multimedia on 13/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import IssueCollector

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		IssueCollector.shared.startObserving(with: .shake, app: self)
		return true
	}

}

