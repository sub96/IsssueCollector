//
//  String + BulletPoint.swift
//  IssueCollector
//
//  Created by Suhaib on 07/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

extension UITextView {
    func addBulletPoint() {
        if self.text.suffix(2).contains("\n") {
            let text = self.text.dropLast(2)
            self.text = text + "\n\u{2022} "
        }
    }
}

