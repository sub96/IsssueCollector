//
//  PickerRowView.swift
//  IssueCollector
//
//  Created by Suhaib on 24/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import Nuke

class PickerRowView: UIView, XibConnected {

    @IBOutlet private weak var projectImage: UIImageView!
    @IBOutlet private weak var projectName: UILabel!
    
    private lazy var nuke = NukeImageLoader()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        connectXib(to: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        connectXib(to: self)
    }
    
    func configure(projectName: String, projectImageURL: URL) {
        self.projectName.text = projectName
        nuke.loadImage(with: projectImageURL, into: projectImage)
    }
}
