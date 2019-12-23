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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleScrenshoot),
                                               name: UIApplication.userDidTakeScreenshotNotification,
                                               object: nil)
    }

    @objc private func handleScrenshoot() {
        print("ScreenShoot!")
        let image = try! UIImage(data: Data(contentsOf: URL(string: "https://www.google.co.in/logos/doodles/2017/mohammed-rafis-93th-birthday-5885879699636224.2-l.png")!))
        let urlString = "https://www.google.com/any-link-to-share"
        
        let activityVC = UIActivityViewController(activityItems: [urlString, image!], applicationActivities: nil)
        
        let root = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController
        
        root?.present(activityVC, animated: true, completion: nil)
    }
}
