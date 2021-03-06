//
//  ReportIssueViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 02/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class ReportIssueViewController: UIViewController {

    @IBOutlet private weak var projectButton: UIButton!
    @IBOutlet private weak var issueTypeButton: UIButton!
    @IBOutlet private weak var priorityButton: UIButton!
    @IBOutlet private weak var summaryStackView: UIStackView!
    @IBOutlet private weak var descriptionStackView: UIStackView!
    @IBOutlet private weak var issueTypeStackView: UIStackView!
    @IBOutlet private weak var stepToReproduceStackView: UIStackView!
    @IBOutlet private weak var environmentStackView: UIStackView!
    @IBOutlet private weak var priorityStackView: UIStackView!
    @IBOutlet private weak var pickerView: CustomPickerView! {
        didSet {
            pickerView.delegate = self
        }
    }

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
    
    @IBOutlet weak var scrollView: UIScrollView!
    private let viewModel = ReportIssueViewModel()
    private var activeField: UITextField?
    private var activeTextView: UITextView?

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
        startKeyboardObserving()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func checkDefaultSettings() {
        self.stepToReproduceStackView.isHidden = true
        self.priorityStackView.isHidden = true

        viewModel.checkForDefaultSettings { [weak self] response in
            switch response {
            case .success(let defaultData):
                guard let defaultData = defaultData else {
                    self?.prepareInitialState()
                    return
                }
                UIView.animate(withDuration: 0.2) {
                    self?.projectButton.setTitle(defaultData.projectName,
                                                 for: .normal)
                    self?.issueTypeButton.setTitle(defaultData.issueType ?? "",
                                                   for: .normal)
                    self?.stepToReproduceStackView.isHidden = defaultData.projectFields.stepsToReproduce == nil
                    self?.priorityStackView.isHidden = defaultData.projectFields.priorities == nil
                }
                
            case .failure(let error):
                self?.presentAlert(with: error.localizedDescription)
                self?.prepareInitialState()

            }
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
        self.priorityStackView.isHidden = true
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
            break
//            configureWithProjects()
            
        case 1:
            break
//            configureWithIssueType()
            
        case 2:
            configureWithPriorities()
            
        default:
            break
        }
    }
    
//    private func configureWithProjects() {
//        let dataSource = viewModel.jiraProvider.project.asProject()
//        self.pickerView.configure(with: dataSource, and: 0)
//        self.pickerView.isShowingPicker.toggle()
//    }
    
    private func configureWithIssueType() {
        guard let dataSource = viewModel.issueTypes else { return }
        self.pickerView.configure(with: dataSource, and: 1)
        self.pickerView.isShowingPicker.toggle()
    }
    
    private func configureWithPriorities() {
        guard let dataSource = viewModel.priorities?.asPriorities() else { return }
        self.pickerView.configure(with: dataSource, and: 2)
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
            self.viewModel.getProjectFields(with: currentElement.id) { [weak self] result in
                switch result {
                case .success(let projectFields):
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.descriptionStackView.isHidden = false
                        self?.issueTypeStackView.isHidden = false
                        self?.summaryStackView.isHidden = false
                        self?.environmentStackView.isHidden = false
                        self?.stepToReproduceStackView.isHidden = projectFields.stepsToReproduce == nil
                    }

                case .failure(let error):
                    self?.presentAlert(with: error.localizedDescription)
                }
            }
            
        case 1:
            self.viewModel.addIssueTypeID(currentElement.id)
            
        case 2:
            self.viewModel.addPriority(currentElement.id)
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
            
        case 2:
            self.priorityButton.setTitle(element.name,
                                         for: .normal)
        
        default: break
        
        }
    }
}

extension ReportIssueViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
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
        activeTextView = textView
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
        activeTextView = nil
        if textView.text.isEmpty {
            switch textView {
            case descriptionTextView:
                textView.text = "Please add a descriptions"

            case stepToReproduceTextView:
                textView.text = "Please add the steps to reproduce"

            default:
                break
            }
            textView.textColor = UIColor.lightGray
        }
        
        switch textView {
        case descriptionTextView:
            self.viewModel.addDescription(descriptionTextView.text)

        case stepToReproduceTextView:
            self.viewModel.addStepToReproduce(stepToReproduceTextView.text)
            
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

extension ReportIssueViewController {
    
    func startKeyboardObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize!.height, right: 0.0)

        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            var point = activeField.frame.origin
            point.y += activeField.frame.size.height
            if (!aRect.contains(point)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        let info = notification.userInfo!
        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
       // self.scrollView.isScrollEnabled = false
    }
}
