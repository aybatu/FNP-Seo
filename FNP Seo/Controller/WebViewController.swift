//
//  WebViewController.swift
//  FNP Seo
//
//  Created by Aybatu Kerkukluoglu on 29.06.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var url: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = URL(string: url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        webView.load(URLRequest(url: urlString!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}
