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
    private var isShakeGestureActive = false
    
    deinit {
        print("Issue collector deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    public func startObserving(with gesture: Gesture) {
        print("start observing..")
        IQKeyboardManager.shared.enable = true
        
        switch gesture {
        case .screenshot:
            NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { [weak self] _ in
                self?.presentFlow()

            }
        case .shake:
            self.isShakeGestureActive = true
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
