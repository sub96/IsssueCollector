//
//  CustomPickerView.swift
//  IssueCollector
//
//  Created by Suhaib on 24/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit

class CustomPickerView: UIView, XibConnected {

    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
           
        }
    }
    @IBOutlet private weak var pickerView: UIPickerView!

    typealias element = (name: String, url: URL)
    
    private var dataSource: [element] = []
    
    var isShowingPicker = true {
        didSet {
            isShowingPicker == true ?
                hidePicker() : showPicker()
        }
    }
    
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
    
    
    func configure(with dataSource: [element]) {
        self.dataSource = dataSource
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
    private func hidePicker() {
         UIView.animate(withDuration: 0.2) {
             self.pickerView.transform = CGAffineTransform.init(translationX: 0,
                                                                y: 1000)
             self.pickerView.isHidden = true
         }
     }
     
     private func showPicker() {
         UIView.animate(withDuration: 0.2) {
             self.pickerView.transform = .identity
             self.pickerView.isHidden = false
         }
     }
}

extension CustomPickerView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let filter = searchTextField.text else { return true }
        let new = dataSource.filter { (element) in
            element.name.contains(filter)
        }
        self.dataSource = new
        
        return true
    }
}
