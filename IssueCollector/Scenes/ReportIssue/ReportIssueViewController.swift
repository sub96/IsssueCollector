//
//  ReportIssueViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class ReportIssueViewController: UIViewController {

    @IBOutlet private weak var pickerView: CustomPickerView! {
        didSet {
            pickerView.delegate = self
        }
    }
    @IBOutlet private weak var projectButton: UIButton!
    @IBOutlet private weak var issueTypeButton: UIButton!
    @IBOutlet private weak var summaryTextField: UITextField! {
        didSet {
            summaryTextField.delegate = self
        }
    }
	@IBOutlet private weak var environmentTextField: UITextField! {
		didSet {
			environmentTextField.delegate = self
		}
	}
	@IBOutlet private weak var descriptionTextView: UITextView! {
        didSet {
			descriptionTextView.configureTextView(with: "Add a description ",
												  delegate: self)
			descriptionTextView.adjustSize()
        }
    }
    @IBOutlet private weak var stepToReproduceTextView: UITextView! {
        didSet {
			stepToReproduceTextView.configureTextView(with: "Add the steps to reproduce",
													  delegate: self)
			stepToReproduceTextView.adjustSize()

        }
    }
    
    @IBOutlet private weak var summaryStackView: UIStackView!
    @IBOutlet private weak var descriptionStackView: UIStackView!
    @IBOutlet private weak var issueTypeStackView: UIStackView!
    @IBOutlet private weak var stepToReproduceStackView: UIStackView!
	@IBOutlet private weak var environmentStackView: UIStackView!
	
    private let viewModel = ReportIssueViewModel()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        if #available(iOS 13, *) {
            return UIActivityIndicatorView.init(style: .medium)
        } else {
            return UIActivityIndicatorView.init(style: .white)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        configureTapToDismiss()
        checkDefaultSettings()
    }
    
    private func checkDefaultSettings() {
        let defaultManager = DefaultManager()
        
        if let settings = defaultManager.getDefaultSettings() {
            self.projectButton.setTitle(settings.project.name,
                                              for: .normal)
            viewModel.addProjectID(settings.project.id)
            
            if let issueType = settings.issueType {
                self.issueTypeButton.setTitle(issueType.name,
                                              for: .normal)
                viewModel.addIssueTypeID(issueType.id)
            }
			viewModel.getProjectFields(with: settings.project.id)
			
        } else {
            prepareInitialState()
        }
    }
    
    private func configureNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        let indicator = UIBarButtonItem.init(customView: self.activityIndicator)
        self.activityIndicator.isHidden = true
        self.navigationItem.rightBarButtonItem = indicator
    }
    
    private func configureTapToDismiss() {
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(hidePicker))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hidePicker() {
        !self.pickerView.isShowingPicker ?
            self.pickerView.isShowingPicker.toggle() : ()
        self.view.endEditing(true)
    }
    
    private func prepareInitialState() {
        self.descriptionStackView.isHidden = true
        self.issueTypeStackView.isHidden = true
        self.summaryStackView.isHidden = true
        self.stepToReproduceStackView.isHidden = true
		self.environmentStackView.isHidden = true
    }
    
    @IBAction func reportIssueButtonPressed(_ sender: Any) {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.viewModel.createIssue { [weak self] result in
            switch result {
            case .success:
                self?.activityIndicator.isHidden = true
                self?.presentSuccessAlert()
                
            case .failure(let error):
                self?.presentAlert(with: error.localizedDescription)
            }
        }
    }
    
    @IBAction private func pickerViewButtonPressed(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        self.view.endEditing(true)
        
        switch button.tag {
        case 0:
            configureWithProjects()
            
        case 1:
            configureWithIssueType()
            
        default: break
        }
    }
    
    private func configureWithProjects() {
        let dataSource = viewModel.jiraProvider.projects.asProject()
        self.pickerView.configure(with: dataSource, and: 0)
        self.pickerView.isShowingPicker.toggle()
    }
    
    private func configureWithIssueType() {
        guard let dataSource = viewModel.projectDetails?.asIssueType() else { return }
        self.pickerView.configure(with: dataSource, and: 1)
        self.pickerView.isShowingPicker.toggle()
    }
}

extension ReportIssueViewController: CustomPickerControllerDelegate {
    func doneButtonPressed(_ picker: CustomPickerView, tag: Int?) {
        guard let tag = tag,
            let currentElement = picker.currentElement else { return }

        switch tag {
        case 0:
            self.viewModel.addProjectID(currentElement.id)
            self.viewModel.getProjectDetails(with: currentElement.id) { result in
                switch result {
                case .success:
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.descriptionStackView.isHidden = false
                        self?.issueTypeStackView.isHidden = false
                        self?.summaryStackView.isHidden = false
                        self?.stepToReproduceStackView.isHidden = false
						self?.environmentStackView.isHidden = false
                    }

                case .failure(let error):
                    self.presentAlert(with: error.localizedDescription)
                }
            }
            
        case 1:
            self.viewModel.addIssueTypeID(currentElement.id)
            
        default:
            break
        }
        self.hidePicker()
    }
    
    func didSelect(_ picker: CustomPickerView, element: PickerElement, and tag: Int?) {
        guard let tag = tag else { return }
        switch tag {
        case 0:
            self.projectButton.setTitle(element.name,
                                        for: .normal)
            
        case 1:
            self.issueTypeButton.setTitle(element.name,
                                          for: .normal)
        
        default: break
        
        }
    }
}

extension ReportIssueViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case summaryTextField:
            self.viewModel.addSummary(textField.text ?? "")

		case environmentTextField:
			self.viewModel.addEnvironment(textField.text ?? "")

        default:
            break
        }
    }
}

extension ReportIssueViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            if textView == stepToReproduceTextView {
                textView.text = "\u{2022} "
            } else {
                textView.text = ""
            }
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please add the steps to reproduce"
            textView.textColor = UIColor.lightGray
        }
        
        switch textView {
        case descriptionTextView:
            self.viewModel.addDescription(descriptionTextView.text)

        case stepToReproduceTextView:
            break
            
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == stepToReproduceTextView {
            if text.contains("\n") {
                textView.text = textView.text + "\n\u{2022} "
				textView.adjustSize()
                return false
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
		textView.adjustSize()
    }
}
