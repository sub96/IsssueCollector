//
//  DetailsViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 23/12/2019.
//  Copyright © 2019 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import ReplayKit

class DetailsViewController: UIViewController {


    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet private var buttons: [UIButton]!
        
    private var previewType: Previewtype?
    private var confettiContainerView: ConfettiContainerView?
    private var viewModel = DetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DefaultManager().isNotFirstLaunch {
            viewModel.startInitialFlow { [weak self] response in
                switch response {
                case .success(let userLoggedIn):
                    if userLoggedIn {
                        self?.viewModel.jiraProvider.capturedFile = self?.previewType
                        self?.buttons.forEach { $0.isEnabled = true }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.showConfettiView()
                        }
                    }
                    
                case .failure(let error):
                    self?.presentAlert(with: error.localizedDescription)
                }
            }
        } else {
            showConfettiView()
            DefaultManager().isNotFirstLaunch = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.previewView.configure(with: previewType!)
    }
    
    @IBAction func startRecordingButtonPressed(_ sender: Any) {
        let recorder = RPScreenRecorder.shared()
        
        recorder.startRecording { [unowned self] error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let stopButton = StopRecordingView.init()
                self.dismiss(animated: true) {
                    let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
                    window?.addSubview(stopButton)
                    stopButton.translatesAutoresizingMaskIntoConstraints = false
                    stopButton.trailingAnchor.constraint(equalTo: window!.trailingAnchor).isActive = true
                    stopButton.centerYAnchor.constraint(equalTo: window!.centerYAnchor).isActive = true
                    stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    stopButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
                }
            }
        }
    }
    
    func prepareWith(_ previewType: Previewtype) {
        self.previewType = previewType
    }
}

extension DetailsViewController: ConfettiContainerDelegate {
    
    func showConfettiView() {
        confettiContainerView = ConfettiContainerView()
        self.view.addSubview(confettiContainerView!)
        confettiContainerView?.constraint(to: self.view)
        confettiContainerView?.delegate = self
        confettiContainerView?.startSettingsFlow()
    }
    
    func removeConfettiView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.confettiContainerView?.alpha = 0
        }) { [weak self] _ in
            self?.confettiContainerView?.removeFromSuperview()
            
            self?.viewModel.startInitialFlow { [weak self] response in
                switch response {
                case .success(let userLoggedIn):
                    if userLoggedIn {
                        self?.viewModel.jiraProvider.capturedFile = self?.previewType
                        self?.buttons.forEach { $0.isEnabled = true }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                            self?.showConfettiView()
                        }
                    }
                    
                case .failure(let error):
                    self?.presentAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    func openLogin() {
        let loginVC = LoginViewController()
        let nav = UINavigationController.init(rootViewController: loginVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func goToSettings() {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
}

