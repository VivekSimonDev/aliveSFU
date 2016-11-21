//
//  SFUCASViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-12.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class SFUCASViewController: UIViewController {
    @IBOutlet weak var webContainer: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadCAS()
        
        // Change this when CAS is integrated
        webContainer.isUserInteractionEnabled = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCAS() {
        // TODO - Talk to SFU IT to get registerd
        
        let url = URL(string: "https://cas.sfu.ca/cas/login?service=http://my/url")
        let req = URLRequest(url: url!)
        
        webContainer.loadRequest(req)
        
    }
    
    @IBAction func loginSuccessful(_ sender: UIButton) {
        DataHandler.setUserLoggedIn(isLoggedIn: true)
        
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
    
}
