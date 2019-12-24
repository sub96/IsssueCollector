//
//  SettingsViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var SelectProjectButton: UIButton!
    @IBOutlet private weak var pickerView: CustomPickerView!
    
    private var viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer.init(target: <#T##Any?#>, action: <#T##Selector?#>)
    }
    
    func preparePicker() {
        self.viewModel.getProjects { response in
            let dataSource = response.map { (name: $0.name,
                                             url: $0.avatarUrls.the48X48) }
            self.pickerView.configure(with: dataSource)
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectProjectButtonPressed(_ sender: Any) {
        pickerView.isShowingPicker.toggle()
    }
}

