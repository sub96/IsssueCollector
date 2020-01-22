//
//  UIViewController + Alert.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(with error: String) {
        let alert = UIAlertController.init(title: "Something went wrong",
                                       message: error,
                                       preferredStyle: .alert)

        alert.addAction(UIAlertAction.init(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentSuccessAlert() {
        let alert = UIAlertController.init(title: "Issue succesfully created!",
                                       message: "Wohooo",
                                       preferredStyle: .alert)

        alert.addAction(UIAlertAction.init(title: "Ok", style: .default) { _ in
            let presenting = self.presentingViewController
            alert.dismiss(animated: true) {
                presenting?.dismiss(animated: true, completion: nil)
            }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentFailureAlert(with description: String) {
        let alert = UIAlertController.init(title: "Something went wrong",
                                       message: description,
                                       preferredStyle: .alert)

        alert.addAction(UIAlertAction.init(title: "Ok", style: .default) { _ in
            let presenting = self.presentingViewController
            alert.dismiss(animated: true) {
                presenting?.dismiss(animated: true, completion: nil)
            }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
}
