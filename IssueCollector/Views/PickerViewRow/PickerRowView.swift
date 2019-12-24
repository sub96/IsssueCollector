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
        
        var imageRequest = ImageRequest.init(url: projectImageURL)
        guard let loginData = String(format: "\("saghir@d-tt.nl"):\("KR8x2M6urnyOA7KH4Cum1693")")
                    .data(using: .utf8) else { return }
        
        
        imageRequest.urlRequest.addValue("Basic \(loginData.base64EncodedString())",
                                         forHTTPHeaderField: "Authorization")
        
//        Nuke.loadImage(with: imageRequest,
//                       options: .init(placeholder: UIImage.init(named: "reload-ic"),
//                                      transition: .fadeIn(duration: 0.2),
//                                      failureImage: UIImage.init(named: "reload-ic"),
//                                      failureImageTransition: .fadeIn(duration: 0.2),
//                                      contentModes: .none),
//                       into: projectImage,
//                       progress: nil,
//                       completion: nil)
    
        Nuke.loadImage(with: imageRequest, into: projectImage)
    }
}
