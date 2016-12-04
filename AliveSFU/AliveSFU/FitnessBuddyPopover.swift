//
//  FitnessBuddyPopover.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-12-02.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class FitnessBuddyPopover: UIViewController {
    
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var frequency: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    weak var rootViewController: UIViewController? //TODO: find something more elegant
    
    var uuid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        self.showAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func rejectBtn(_ sender: AnyObject) {
        
    }
    
    @IBAction func acceptBtn(_ sender: UIButton) {
        
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}

