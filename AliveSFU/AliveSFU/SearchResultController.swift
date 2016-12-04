//
//  SearchResultController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-12-02.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class SearchResultController: UIViewController, UIGestureRecognizerDelegate {
    
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
        populateStackView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.isNavigationBarHidden = false
        
    }
    /* Member Functions*/
    
    func sendRequestToBuddy(buddy: firebaseProfile) {
        // let
    }
    
    // updates isDeleted flag of that BuddyTile to true
    // Reloads search results by calling reloadBuddy
    func deleteBuddyFromResults(tile: BuddyTileView) {
        
        tile.setIsDeleted()
        reloadBuddy()
        
    }
    
    //on slide gesture, perform one of the following functions depending on the gesture:
    // > sendRequestToBuddy, or
    // > deleteBuddyFromResults
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
                //let view = gesture.view as! BuddyTileView;
                //sendRequestToBuddy(buddy: buddy)
                //updateChartData()
                
            } else if (gesture.view!.frame.origin.x - self.panTileOrigin.x > 50) {
                let view = gesture.view as! BuddyTileView;
                deleteBuddyFromResults(tile: view)
                
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
        popoverVC.name.text = tile.name.text
        popoverVC.goals.text = tile.goals.text
        
        popoverVC.didMove(toParentViewController: self)
        
    }


    func reloadBuddy(){
        
        //this function will be called when we want to reload teh buddy view but not include the deleted tiles
        
        //since the view is now changed, get rid of all preexisting subviews
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        if buddyTiles.isEmpty == false {
            for tile in buddyTiles{
                if (tile.getIsDeleted() == false) {
                    
                    let frame = CGRect(x: 0, y: CGFloat(contentView.subviews.count) * (TILE_HEIGHT + 5), width: scrollView.bounds.width, height: TILE_HEIGHT)
                    
                    //let tile = BuddyTileView(frame: , name: hash.name, goals: hash.goals, age: hash.age, freq: hash.freq)
                    //tile.uuid = buddy.id
                    let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
                    tile.addGestureRecognizer(tapGesture)
                    
                    let slideGesture = UIPanGestureRecognizer(target: self, action: #selector (self.tileSlideGesture(_:)))
                    slideGesture.delegate = self
                    tile.addGestureRecognizer(slideGesture)
                    //scrollView.panGestureRecognizer.require(toFail: slideGesture)
                    contentView.addSubview(tile)
                }
            }
        }
        else {
            //Display Placeholder Exercise Tile
            
            // Create a new image for this placeholder
            
            /*
             let placeholder = UIImageView(image: UIImage(named: "noExercisePlaceholder"))
             placeholder.tag = PLACEHOLDER_TAG
             placeholder.frame = CGRect(x: 0, y: -40, width: self.view.frame.width - 40, height: 500)
             contentView.addSubview(placeholder)
             */
        }
        
    }
    
    func populateStackView() {
        //since the view is now changed, get rid of all preexisting subviews
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        //Populate Exercise Tiles
        let firebaseCtlr = firebaseController()
        /*firebaseCtlr.returnClosestMatch(weight: 5, function: {profile in
            self.buddies = profile
            print(self.buddies)
            var count = 0
            for buddy in self.buddies {
                //let hashToFields =          //Wait for liam to finish it
                
                // Add func showPopup that will show the popup > ADDED
                // Add func tileSlideGesture that will send a request to the
                //          particular user
                // > ADDED function to delete buddy from search results
                
                
                let frame = CGRect(x: 0, y: CGFloat(self.contentView.subviews.count) * (self.TILE_HEIGHT + 5), width: self.scrollView.bounds.width, height: self.TILE_HEIGHT)
                
                let tile = BuddyTileView(frame: frame, name: hash.name, goals: hash.goals, age: hash.age, freq: hash.freq)
                
                tile.uuid = buddy.devID
                
                let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
                tile.addGestureRecognizer(tapGesture)
                
                let slideGesture = UIPanGestureRecognizer(target: self, action: #selector (self.tileSlideGesture(_:)))
                slideGesture.delegate = self
                tile.addGestureRecognizer(slideGesture)
                //scrollView.panGestureRecognizer.require(toFail: slideGesture)
                buddyTiles.append(tile)
                contentView.addSubview(tile)
            }
            count += 1;
            //}
            if (count == 0) {
                //Display Placeholder Exercise Tile
                
                // Create a new image for this placeholder
                
                /*
                 let placeholder = UIImageView(image: UIImage(named: "noExercisePlaceholder"))
                 placeholder.tag = PLACEHOLDER_TAG
                 placeholder.frame = CGRect(x: 0, y: -40, width: self.view.frame.width - 40, height: 500)
                 contentView.addSubview(placeholder)
                 */
            }
        })
    }*/
    }

 }
