//
//  IssueCollector.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

public final class IssueCollector {
    
    public static var shared = IssueCollector()
    
    deinit {
        print("Issue collector deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    public func startObserving() {
        print("start observing..")
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: .main) { notification in

            guard let app = notification.object as? UIApplication,
                let window = app.windows.filter({ $0.isKeyWindow }).first
                else { return }
            
            guard let image = window.rootViewController?.view.asImage() else { return }
            
            guard let vc = UIStoryboard.init(name: "Details", bundle: Bundle.init(for: Self.self)).instantiateInitialViewController() as? DetailsViewController else { return }
            vc.prepareWith(image)
            
            window.rootViewController?.present(vc, animated: true, completion: nil)
        }
    }
}
