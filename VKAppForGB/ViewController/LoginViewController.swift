//
//  LoginViewController.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 12.08.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
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

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard
            let url = navigationResponse.response.url,
            url.path == "/blank.html",
            let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let paramethers = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String] () ) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        guard let token = paramethers["access_token"],
            let userIdString = paramethers["user_id"],
        let userId = Int(userIdString) else {
            decisionHandler(.allow)
            return
        }
        
        Session.current.token = token
        Session.current.userId = userId
        
        print("token = \(Session.current.token)")
        print("userId = \(Session.current.userId)")

        decisionHandler(.cancel)
        performSegue(withIdentifier: "webViewLogin", sender: nil)
    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared
        for cookie in cookieJar.cookies! {
            cookieJar.deleteCookie(cookie)
        }
    }
}
