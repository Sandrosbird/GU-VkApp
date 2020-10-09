//
//  LoginViewController+WKNavigationDelegate.swift
//  VKAppForGB
//
//  Created by Emil Mescheryakov on 08.10.2020.
//  Copyright © 2020 Emil Mescheryakov. All rights reserved.
//

import UIKit
import WebKit

extension LoginViewController {
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
