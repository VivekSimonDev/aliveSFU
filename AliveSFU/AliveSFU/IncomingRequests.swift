//
//  IncomingRequests.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-29.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class IncomingRequests: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    var buddies = [firebaseProfile]()
    var buddyTiles = [BuddyTileView]()
    var panTileOrigin = CGPoint(x: 0, y: 0)
    
    let TILE_HEIGHT = CGFloat(80)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = true
        populateSearch()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
        
    }
    /* Member Functions*/
    
    func tileSlideGesture(_ gesture: UIPanGestureRecognizer) {
        if (gesture.state == .began) {
            self.panTileOrigin = gesture.view!.frame.origin
        }
        if (gesture.state == .began || gesture.state == .changed) {
            let translation = gesture.translation(in: contentView)
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x/2, y: gesture.view!.center.y)
            gesture.setTranslation(CGPoint.zero, in: contentView)
        } else if (gesture.state == .ended) {
            if (self.panTileOrigin.x - gesture.view!.frame.origin.x > 50){
                let view = gesture.view as! BuddyTileView;
                
                //Send request to this buddy
                DataHandler.addOutgoingRequest(req: view.dbprofile)
                setTileBGColor(isCompleted: true, view: view)
                let ctrl = firebaseController()
                ctrl.sendRequest(user: view.dbprofile) //send a request to this user
            } else if (gesture.view!.frame.origin.x - self.panTileOrigin.x > 50) {
                //let view = gesture.view as! BuddyTileView;
                
                //updateChartData()
            }
            UIView.animate(withDuration: 0.1, animations: {gesture.view!.frame.origin = self.panTileOrigin})
        }
    }
    
    // show Popup with buddy info on tap gesture
    @IBAction func showPopup(_ sender: UITapGestureRecognizer) {
        
        //if (sender.view?.tag == CATEGORY_CARDIO_VIEW_TAG) {
        let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fitnessBuddyPopover") as! FitnessBuddyPopover
        self.addChildViewController(popoverVC)
        popoverVC.view.frame = self.view.frame
        popoverVC.view.tag = 600
        popoverVC.rootViewController = self
        self.view.addSubview(popoverVC.view)
        
        let tile = sender.view as! BuddyTileView
        popoverVC.uuid = tile.uuid
        popoverVC.age.text = tile.age.text
        popoverVC.frequency.text = tile.freq.text
        popoverVC.username = tile.actualName
        popoverVC.name.text = tile.name.text
        popoverVC.goals.text = tile.goalsStr
        
        popoverVC.didMove(toParentViewController: self)
        
    }
    
    func populateSearch() {
        //since the view is now changed, get rid of all preexisting subviews
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
              
        let profile = DataHandler.getIncomingRequests()
        let hashMaker = HashAlgorithm()
        self.buddies = profile
        print(self.buddies)
        var count = 0
        for buddy in self.buddies {
            //check if our user has sent a request for any of these users
            //if so, then a match has been found
            let outgoingRequests = DataHandler.getOutgoingRequests()
            let username = DataHandler.getCurrentUser()
            for elem in outgoingRequests {
                if elem.userName == buddy.userName {
                    //a match has been found!
                    let bd = hashMaker.hashToField(id: DataHandler.getHashNum())
                    
                    let frame = CGRect(x: self.contentView.frame.origin.x + 5, y: 5 + CGFloat(self.contentView.subviews.count) * (self.TILE_HEIGHT + 5), width: self.contentView.bounds.width - 5, height: self.TILE_HEIGHT)
                    
                    let tile = BuddyTileView(frame: frame, name: buddy.userName, goals: bd.personalGoals, age: bd.ageGroup, freq: bd.fitnessFreq)
                    
                    tile.dbprofile = buddy
                    
                    let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
                    tile.addGestureRecognizer(tapGesture)
                    
                    let slideGesture = UIPanGestureRecognizer(target: self, action: #selector (self.tileSlideGesture(_:)))
                    slideGesture.delegate = self
                    tile.addGestureRecognizer(slideGesture)
                    self.buddyTiles.append(tile)
                    self.contentView.addSubview(tile)
                    count += 1;
                }
            }

        }
        self.contentViewHeight.constant = CGFloat(self.contentView.subviews.count) * (self.TILE_HEIGHT + 5)
    }
    func setTileBGColor(isCompleted: Bool, view: BuddyTileView) {
        let SFURed = UIColor(red: 166, green: 25, blue: 46)
        if (isCompleted) {
            view.mainView.backgroundColor = SFURed.withAlphaComponent(0.5)
            view.checkmark.isHidden = false
        } else {
            view.mainView.backgroundColor = SFURed
            view.checkmark.isHidden = true
        }
    }

}
