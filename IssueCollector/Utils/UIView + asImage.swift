//
//  UIView + asImage.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

extension UIView {
    // Name image might conflict with an existing variable (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func constraint(
        to parent: UIView,
        with insets: UIEdgeInsets = .zero
        ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                self.topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
                self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: insets.bottom),
                self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.right),
                self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: insets.left)
            ]
        )
    }
}
