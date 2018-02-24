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

    @IBAction func changePage(_ sender: Any) {
        let myURL = URL(string: "https://www.google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    @IBOutlet weak var innerView: UIView!
    
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        webView = WKWebView(frame: innerView.bounds, configuration: webConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        userContentController.add(self, name: "doStuff")
        webView.uiDelegate = self
        webView.navigationDelegate = self

        print(innerView.subviews.count)
//        innerView = webView
        print(innerView.subviews.count)
//        let myURL = URL(string: "http://localhost:1337/index.html")
        let myURL = URL(string: "https://www.apple.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        innerView.addSubview(webView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let data = message.body as! [String:AnyObject]
        let result = data["amount"] as! NSNumber
        print("WebView button clicked : \(result)")
        webView.evaluateJavaScript("amount.value", completionHandler: { (result: Any?, error: Error?) in
            if let msg = error {
                print("Received an error from JS: \(msg)")
            }
            else {
                print("Amount: \(result)")
            }
        })
        
        innerView.willRemoveSubview(webView)
        webView.removeFromSuperview()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // For passing more complicated data, it most likely needs to be encoded into a string
        // See: https://stackoverflow.com/questions/32113933/how-do-i-pass-a-swift-object-to-javascript-wkwebview-swift

        let message = "From iOS."
        webView.evaluateJavaScript("onUpdate('\(message)')", completionHandler: { (result: Any?, error: Error?) in
            if let msg = error {
                print("Received an error from JS: \(msg)")
            }
            else {
                print("Js execution successful. Result: \(result)")
            }
        })
    }

}

