//
//  TutorialsDisclaimerViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-30.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class TutorialsDisclaimerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func openLink(_ sender: AnyObject) {
        if let url = URL(string: "https://www.sfu.ca/students/recreation/active/Policies.html") {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
                // do something with the boolean
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
