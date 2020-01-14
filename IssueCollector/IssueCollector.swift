//
//  IssueCollector.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import CoreMotion
import IQKeyboardManagerSwift

public enum Gesture {
    case shake
    case screenshot
}

public final class IssueCollector {
    
    public static var shared = IssueCollector()
	private var motionManager: CMMotionManager!
    
	private lazy var xInPositiveDirection = 0.0
	private lazy var xInNegativeDirection = 0.0
	private lazy var shakeCount = 0
	private lazy var tempVariable = 0
		
    deinit {
        print("Issue collector deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
	public func startObserving(with gesture: Gesture, app: UIApplicationDelegate) {
        print("start observing..")
		
        IQKeyboardManager.shared.enable = true

		switch gesture {
        case .screenshot:
            NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { [weak self] _ in
                self?.presentFlow()

            }
        case .shake:
			motionManager = CMMotionManager()
			motionManager.deviceMotionUpdateInterval = 0.02
			motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
				guard let self = self else { return }
				if data!.userAcceleration.x > 1.0 {
					self.xInPositiveDirection = data!.userAcceleration.x
				 }

				 if data!.userAcceleration.x < -1.0 {
					self.xInNegativeDirection = data!.userAcceleration.x
				 }

				if self.xInPositiveDirection != 0.0 && self.xInNegativeDirection != 0.0 {
					self.shakeCount = self.shakeCount + 1
					self.xInPositiveDirection = 0.0
					self.xInNegativeDirection = 0.0
				 }

				if self.shakeCount > 5 {
					self.tempVariable = self.tempVariable + 1
					self.shakeCount = 0
					self.presentFlow()
				 }
			}
        }
    }
    
    func presentFlow() {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first
            else { return }
        
        guard let image = window.rootViewController?.view.asImage() else { return }
        
        guard let nav = UIStoryboard.init(name: "Details", bundle: Bundle.init(for: Self.self)).instantiateInitialViewController() as? UINavigationController,
            let vc = nav.topViewController as? DetailsViewController else { return }
        vc.prepareWith(.image(image))
        
        window.rootViewController?.present(nav, animated: true, completion: nil)
    }
}
