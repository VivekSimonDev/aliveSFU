//
//  SFUCASViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-12.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import WebKit

class SFUCASViewController: UIViewController, WKNavigationDelegate, XMLParserDelegate {
    
    let CAS_TEST_HOST = "cas-test.sfu.ca"
    let REDIRECT_PATH = "/~gkohli/alive-sfu-login.html"
    let SERVICE_URL = "service=http://www.sfu.ca/~gkohli/alive-sfu-login.html"
    let CAS_VALIDATE_URL = "https://cas-test.sfu.ca/stage/serviceValidate"
    let XML_AUTH_FAIL_TAG = "cas:authenticationFailure"
    let XML_USER_TAG = "cas:user"
    
    var didAuthSucceed = false
    var readingUsername = false
    var readingAuthFailedMsg = false
    var username = ""
    var authFailedMsg = ""
    
    private weak var webView: WKWebView?
    private weak var loadingIndicator: UIActivityIndicatorView?
    private var userContentController: WKUserContentController?
    var parserXML = XMLParser()

    @IBOutlet weak var webContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createWebView()
        createLoadingIndicator()
        webView?.navigationDelegate = self
        loadCAS()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    private func createLoadingIndicator() {
        let loadingIndicator = UIActivityIndicatorView(frame: webContainer.bounds)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.color = UIColor(red: 166, green: 25, blue: 46)
        loadingIndicator.stopAnimating()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        webContainer.addSubview(loadingIndicator)
        
        let centerX = NSLayoutConstraint(item: webContainer, attribute: .centerX, relatedBy: .equal, toItem: loadingIndicator, attribute: .centerX, multiplier: 1, constant: 1)
        let centerY = NSLayoutConstraint(item: webContainer, attribute: .centerY, relatedBy: .equal, toItem: loadingIndicator, attribute: .centerY, multiplier: 1, constant: 1)
        let width = NSLayoutConstraint(item: webContainer, attribute: .width, relatedBy: .equal, toItem: loadingIndicator, attribute: .width, multiplier: 1, constant: 10)
        let height = NSLayoutConstraint(item: webContainer, attribute: .height, relatedBy: .equal, toItem: loadingIndicator, attribute: .height, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        self.loadingIndicator = loadingIndicator
    }
    
    private func createWebView() {
        userContentController = WKUserContentController()
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController!
        
        let webView = WKWebView(frame: webContainer.bounds, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webContainer.addSubview(webView)
        
        let centerX = NSLayoutConstraint(item: webContainer, attribute: .centerX, relatedBy: .equal, toItem: webView, attribute: .centerX, multiplier: 1, constant: 1)
        let centerY = NSLayoutConstraint(item: webContainer, attribute: .centerY, relatedBy: .equal, toItem: webView, attribute: .centerY, multiplier: 1, constant: 1)
        let width = NSLayoutConstraint(item: webContainer, attribute: .width, relatedBy: .equal, toItem: webView, attribute: .width, multiplier: 1, constant: 10)
        let height = NSLayoutConstraint(item: webContainer, attribute: .height, relatedBy: .equal, toItem: webView, attribute: .height, multiplier: 1, constant: 10)
        
        NSLayoutConstraint.activate([centerX, centerY, width, height])
        
        self.webView = webView
    }
    
    func startLoadUI() {
        loadingIndicator?.startAnimating()
        webView?.alpha = 0.3
    }
    
    func stopLoadUI() {
        loadingIndicator?.stopAnimating()
        webView?.alpha = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCAS() {
        // TODO - Talk to SFU IT to get registerd
        
        let url = URL(string: "https://cas-test.sfu.ca/stage/login?service=http://www.sfu.ca/~gkohli/alive-sfu-login.html")
        let req = URLRequest(url: url!)
        webView!.load(req)
    }
    
    func loginSuccessful() {
        // Set the username as the current user name
        DataHandler.setCurrentUser(username: username)
        // Initialize data if the user has never logged in to this device
        DataHandler.initDataHandlerData()
        DataHandler.setUserLoggedIn(isLoggedIn: true)
        
        //Stop Loading UI
        stopLoadUI()
        
        let flags = DataHandler.getFlags()
        
        if let userProfileExists = flags.profileExists {
            if (userProfileExists) {
                
                //User profile exists, take user to main storyboard (Home page)
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateInitialViewController()!
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                
                self.present(vc, animated: true, completion: nil)
            } else {
                
                //User profile doesn't exist. Take user to first time login
                let sb = UIStoryboard(name: "firstTime", bundle: nil)
                let vc = sb.instantiateInitialViewController()!
                vc.modalPresentationStyle = .fullScreen
                vc.modalTransitionStyle = .crossDissolve
                
                self.present(vc, animated: true, completion: nil)
            }
        } 
    }
    
    func loginFailed() {
        // Login failed. Take user back to main login screen. 
        // Maybe also have an error 
        stopLoadUI()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // Webview Delegate Function
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url!
        if (url.path == REDIRECT_PATH) {
            // Show user UI so that they know loading is occuring
            startLoadUI()
            let ticket = url.query //This is the ticket
            
            let urlString = CAS_VALIDATE_URL + "?" + ticket! + "&" + SERVICE_URL
            let validateURL = URL(string: urlString)
            
            let request = URLRequest(url: validateURL!)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                self.parserXML = XMLParser(data: data)
                self.parserXML.delegate = self
                self.parserXML.parse()
            }
            task.resume()
            decisionHandler(.cancel)
        }
        
        decisionHandler(.allow)
    }
    
    // XML Parser Delegate Functions
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if (elementName == XML_AUTH_FAIL_TAG) {
            // Authentication failed. Stop reading message and update flag
            didAuthSucceed = false
            readingAuthFailedMsg = false
        }
        if (elementName == XML_USER_TAG) {
            // Read username. Stop reading and update flag
            didAuthSucceed = true
            readingUsername = false
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if (elementName.contains(XML_AUTH_FAIL_TAG)) {
            // Authentication failed. Start reading error msg
            readingAuthFailedMsg = true
        }
        if (elementName == XML_USER_TAG) {
            // Found username. Start reading
            readingUsername = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Capture characters if they're part of username
        if (readingUsername) {
            username += string
        }
        if (readingAuthFailedMsg) {
            authFailedMsg += string
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        // Parsing finished. Let user know of the outcome
        if (didAuthSucceed) {
            //Authentication succeeded
            DispatchQueue.main.sync {
                loginSuccessful()
            }
        } else {
            //Authentication failed
            DispatchQueue.main.sync {
                loginFailed()
            }
        }
        
    }
}
