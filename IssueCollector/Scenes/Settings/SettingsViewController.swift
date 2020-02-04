//
//  SettingsViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userEmail: UILabel!
    @IBOutlet private weak var userRole: UILabel!
    @IBOutlet private weak var pickerView: CustomPickerView!
    @IBOutlet private weak var selectProjectButton: UIButton!
    @IBOutlet private weak var issueTypeButton: UIButton!
    @IBOutlet private weak var issueTypeStack: UIStackView!
    
    private var viewModel = SettingsViewModel()
    private let defaultManager = DefaultManager()
    private let nuke = NukeImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        configureTapGesture()
                
        viewModel.configureCurrentUser { [weak self] userResponse in
            switch userResponse {
            case .success(let user):
                self?.setCurrentUser(user)
                
            case .failure(let error):
                self?.presentAlert(with: error.localizedDescription)
            }
        }
        
        if let settings = defaultManager.getDefaultSettings() {
            self.selectProjectButton.setTitle(settings.project.name,
                                              for: .normal)
            viewModel.selectedProject = settings.project
            
            if let issueType = settings.issueType {
                self.issueTypeButton.setTitle(issueType.name,
                                              for: .normal)
                viewModel.selectedIssueType = issueType
            } else {
                viewModel.getProjectDetails { [weak self] response in
                    self?.setIssueType()
                    self?.save()
                }
            }
        }
    }
    
    @IBAction func pickerViewButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        
        switch button.tag {
            // Uncomment for multiproject app
//        case 0:
//            configureWithProjects()
//        case 1:
//            configureWithIssueType()
            
        default: break
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        save()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func save() {
        defaultManager.defaultProject = viewModel.selectedProject
        defaultManager.defaultIssueType = viewModel.selectedIssueType
        defaultManager.isNotFirstLaunch = true
    }
    
    private func setCurrentUser(_ user: UserResponse) {
        self.userName.text = user.name
        self.userEmail.text = user.email
        self.userRole.text = user.extendedProfile.jobTitle
        nuke.loadImage(with: user.picture, into: userImageView)
    }
    
    private func setIssueType() {
        guard let issueTypes = self.viewModel.projectDetails?.asIssueType(),
            let bugType = issueTypes.first(where: { $0.name.lowercased().contains("bug") })
            else { return }
        
        self.issueTypeButton.setTitle(bugType.name, for: .normal)
        viewModel.selectedIssueType = bugType
    }
    
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(endEditing))
        self.view.addGestureRecognizer(tap)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func endEditing() {
        !self.pickerView.isShowingPicker ?
            self.pickerView.isShowingPicker.toggle() : ()
    }
}

extension SettingsViewController: CustomPickerControllerDelegate {
    func didSelect(_ picker: CustomPickerView, element: PickerElement, and tag: Int?) {
        guard let tag = tag else { return }
        switch tag {
        case 0:
            selectProjectButton.setTitle(element.name,
                                         for: .normal)
            viewModel.selectedProject = element
            
        case 1:
            issueTypeButton.setTitle(element.name,
                                     for: .normal)
            viewModel.selectedIssueType = element
            
        default:
            break
        }
        
    }

    func doneButtonPressed(_ picker: CustomPickerView, tag: Int?) {
        guard let tag = tag else { return }
        
        switch tag {
        case 0:
            self.viewModel.getProjectDetails { response in
                switch response {
                case .success:
                    UIView.animate(withDuration: 0.2) {
                        self.issueTypeStack.isHidden = false
                    }
                    
                case .failure(let error):
                    self.presentAlert(with: error.localizedDescription)
                }
            }
            
        default:
            break
        }
        endEditing()
    }
    
    // Mark:- Multiprojects
    
//    func configureWithIssueType() {
//        guard let dataSource = viewModel.projectDetails?.asIssueType() else { return }
//        self.pickerView.configure(with: dataSource, and: 1)
//        pickerView.isShowingPicker.toggle()
//    }

//    func configureWithProjects() {
//        let dataSource = viewModel.project.asProject()
//        self.pickerView.configure(with: dataSource, and: 0)
//        pickerView.isShowingPicker.toggle()
//    }

}
