//
//  CustomPickerView.swift
//  IssueCollector
//
//  Created by Suhaib on 24/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

protocol CustomPickerControllerDelegate: class {
    
    /// Called when the user select an element with the picker
    /// - Parameters:
    ///   - picker: CustomPickerView
    ///   - element: the selected element
    ///   - tag: 0: Projects,
    ///          1: IssueType
    func didSelect(_ picker: CustomPickerView, element: PickerElement, and tag: Int?)
    func doneButtonPressed(_ picker: CustomPickerView, tag: Int?)
}

typealias PickerElement = (name: String, url: URL, id: Int)

class CustomPickerView: UIView, XibConnected {

    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }

    @IBOutlet private weak var pickerView: UIPickerView!

    var isShowingPicker = true {
        didSet {
            isShowingPicker == true ?
                hidePicker() : showPicker()
        }
    }

    weak var delegate: CustomPickerControllerDelegate?

    private var dataSource: [PickerElement] = []
    private var currentTag: Int?
    var currentElement: PickerElement?

    override init(frame: CGRect) {
        super.init(frame: frame)
        connectXib(to: self)
        self.hidePicker()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        connectXib(to: self)
        self.hidePicker()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate?.doneButtonPressed(self, tag: currentTag)
    }
    
    func configure(with dataSource: [PickerElement], and tag: Int? = nil) {
        self.dataSource = dataSource
        self.currentTag = tag
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.reloadAllComponents()
    }
}

extension CustomPickerView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerRowView = PickerRowView()
        let data = dataSource[row]
        pickerRowView.configure(projectName: data.name,
                                projectImageURL: data.url)
        
        return pickerRowView
    }
}

extension CustomPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.currentElement = dataSource[row]
        self.delegate?.didSelect(self, element: dataSource[row], and: currentTag)
    }
    
    private func hidePicker() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.init(translationX: 0,
                                                    y: 1000)
            self.isHidden = true
        }
    }
     
    private func showPicker() {
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
            self.isHidden = false
        }
    }
}

extension CustomPickerView: UITextFieldDelegate {
    #warning("TO DO")
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let filter = searchTextField.text else { return true }
        let new = dataSource.filter { (element) in
            element.name.contains(filter)
        }
        self.dataSource = new
        
        return true
    }
}
