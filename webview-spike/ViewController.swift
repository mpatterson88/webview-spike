//
//  ViewController.swift
//  webview-spike
//
//  Created by Michael Patterson on 2/21/18.
//  Copyright © 2018 Michael Patterson. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKScriptMessageHandler, WKNavigationDelegate {
    let userContentController = WKUserContentController()

    
    @IBOutlet weak var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        userContentController.add(self, name: "doStuff")
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "http://localhost:1337/index.html")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let data = message.body as! [String:AnyObject]
        let result = data["foo"] as! String
        print("WebView button clicked : \(result)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // For passing more complicated data, it most likely needs to be encoded into a string
        // See: https://stackoverflow.com/questions/32113933/how-do-i-pass-a-swift-object-to-javascript-wkwebview-swift
        
        let message = "From iOS."
        webView.evaluateJavaScript("onUpdate('\(message)')", completionHandler: { (result: Any?, error: Error?) in
            if let message = error {
                print("Received an error from JS: \(message)")
            }
            else {
               print("Js execution successful")
            }
        })
    }

}

