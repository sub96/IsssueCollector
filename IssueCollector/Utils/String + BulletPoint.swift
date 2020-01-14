//
//  String + BulletPoint.swift
//  IssueCollector
//
//  Created by Suhaib on 07/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

extension UITextView {
	func adjustSize() {
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth,
                                                   height: CGFloat.greatestFiniteMagnitude))
        self.frame.size = CGSize(width: fixedWidth,
								 height: newSize.height)
    }
	
	func configureTextView(with placeholder: String, delegate: UITextViewDelegate) {
        self.delegate = delegate
        self.text = placeholder
        self.textColor = UIColor.lightGray
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(red: 204.0/255.0,
                                                  green: 204.0/255.0,
                                                  blue: 204.0/255.0,
                                                  alpha: 1).cgColor
        self.layer.cornerRadius = 4
        self.translatesAutoresizingMaskIntoConstraints = true
        self.isScrollEnabled = false
    }
}

