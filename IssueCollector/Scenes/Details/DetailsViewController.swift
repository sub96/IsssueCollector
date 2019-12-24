//
//  DetailsViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    
    var capturedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageview.image = capturedImage
    }
    
    func prepareWith(_ image: UIImage) {
        self.capturedImage = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showSettings" {
            guard let destination = segue.destination as? SettingsViewController else { return }
            destination.preparePicker()
        }
    }
}
