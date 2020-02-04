//
//  NukeImageLoader.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation
import Nuke

class NukeImageLoader {
    
    func loadImage(with url: URL, into imageView: UIImageView) {
        
        var imageRequest = ImageRequest.init(url: url)
        guard let token = String.init(data: KeyChain().load(key: KeyChain.Key.accessToken.rawValue) ?? Data(),
                                      encoding: .utf8) else { return }

        imageRequest.urlRequest.addValue("Bearer \(token)",
                                         forHTTPHeaderField: "Authorization")
        
        Nuke.loadImage(with: imageRequest,
                       options: .init(placeholder: UIImage.init(named: "reload-ic"),
                                      transition: .fadeIn(duration: 0.2),
                                      failureImage: UIImage.init(named: "reload-ic"),
                                      failureImageTransition: .fadeIn(duration: 0.2),
                                      contentModes: .none),
                       into: imageView,
                       progress: nil,
                       completion: nil)
    }
}
