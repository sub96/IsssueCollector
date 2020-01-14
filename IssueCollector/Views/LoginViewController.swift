//
//  LoginViewController.swift
//  IssueCollector
//
//  Created by Suhaib on 06/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    
    var webView: WKWebView!
    let keyChain = KeyChain.init()

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL.init(string: "https://auth.atlassian.com/authorize?audience=api.atlassian.com&client_id=gUVPhVEvA21QYAREKVyT17ybPcwPqoJv&scope=read%3Ajira-user%20read%3Ajira-work%20write%3Ajira-work%20offline_access%20read%3Ame&redirect_uri=https%3A%2F%2Fwww.d-tt.nl&state=hard&response_type=code&prompt=consent") else { return }
        
        webView.load(URLRequest.init(url: url))
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let dismiss = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        navigationController?.isToolbarHidden = false
        navigationItem.leftBarButtonItem = dismiss
        navigationItem.rightBarButtonItem = refresh
    }
    
    @objc func done() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url,
            url.queryParameters.first?.name.contains("code") ?? false,
            let code = url.queryParameters.first?.value else { return }
        
        JiraProvider.shared.login(with: code) { [weak self] response in
            switch response {
            case .success(let response):
                self?.keyChain.save(accessToken: response.accessToken,
                                    refreshToken: response.refreshToken)
                
                guard let nav = self?.presentingViewController as? UINavigationController,
                    let details = nav.topViewController as? DetailsViewController
                    else { return }
                self?.dismiss(animated: true, completion: {
                    details.removeConfettiView()
                    DefaultManager().isNotFirstLaunch = true
                })

            case .failure(let error):
                print(error)
            }
        }
    }
}
