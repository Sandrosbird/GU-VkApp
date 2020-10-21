//
//  LoginViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 12.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var loginWebView: WKWebView! {
        didSet {
            loginWebView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeCookies()
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7570767"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "scope", value: "270342"),
            URLQueryItem(name: "v", value: "5.92")
        ]
        let request = URLRequest(url: urlComponents.url!)
        loginWebView.load(request)
    }
}
