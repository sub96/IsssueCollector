//
//  ConfettiView.swift
//  IssueCollector
//
//  Created by Suhaib on 03/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit

protocol ConfettiContainerDelegate: class {
    func openLogin()
}

class ConfettiContainerView: UIView, XibConnected {

    @IBOutlet private weak var confettiContainer: UIView!
    @IBOutlet private weak var thanksLabel: UILabel!
    @IBOutlet private weak var settingsStackView: UIStackView!
    
    var confettiView: ConfettiView?
    
    weak var delegate: ConfettiContainerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        connectXib(to: self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        connectXib(to: self)
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        delegate?.openLogin()
    }
    
    private func dismissView(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    func startSettingsFlow() {
        self.prepareConfettiView()
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.5,
                       options: .transitionCrossDissolve,
                       animations: { [weak self] in
                        self?.thanksLabel.alpha = 1
        }) { [weak self] _ in
            UIView.animate(withDuration: 0.5,
                           delay: 0.5,
                           options: .transitionCrossDissolve,
                           animations: {
                            self?.confettiView?.alpha = 1
                            self?.confettiView?.startConfetti()
            }) { [weak self] _ in
                UIView.animate(withDuration: 0.5,
                               delay: 0.5,
                               options: .transitionCrossDissolve,
                               animations: {
                                self?.settingsStackView.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    private func prepareConfettiView() {
        confettiView = ConfettiView.init(frame: self.frame)
        confettiView?.alpha = 0
        
        self.confettiContainer.addSubview(self.confettiView!)
        self.confettiView?.intensity = 0.85
    }
}

