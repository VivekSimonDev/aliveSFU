
//
//  BuddyTileView.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-12-02.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class BuddyTileView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var freq: UILabel!
    @IBOutlet weak var goals: UILabel!
    @IBOutlet weak var checkmark: UIImageView!
    
    var goalsStr = ""
    var dbprofile = firebaseProfile()
    
    var isDeleted: Bool = false
    var uuid: String = ""
    var actualName : String = ""
    
    let TILE_HEIGHT = CGFloat(20);
    let PADDING = CGFloat(20);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(frame: CGRect, name: String, goals: String, age: Int, freq: Int) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("BuddyTile", owner: self, options: nil);
        self.addSubview(view);    // adding the top level view to the view hierarchy
        
        let origImage = UIImage(named: "Checkmark");
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        checkmark.image = tintedImage
        checkmark.isHidden = true
        
        var ageStr = ""
        switch age {
        case 0:
            ageStr = "17-19"
        case 1:
            ageStr = "20-22"
        case 2:
            ageStr = "23-25"
        case 3:
            ageStr = "26-29"
        case 4:
            ageStr = "30+"
        default:
            ageStr = "20-22"
        }
        
        var freqStr = ""
        switch freq {
        case 0:
            freqStr = "0-5 hrs/wk"
        case 1:
            freqStr = "5-10 hrs/wk"
        case 2:
            freqStr = "10-15 hrs/wk"
        case 3:
            freqStr = "15-20 hrs/wk"
        case 4:
            freqStr = "20+ hrs/wk"
        default:
            freqStr = "0-5 hrs/wk"
        }
        
        var goalsStrArr = [String]()
        let goalsArr = goals.components(separatedBy: ",")
        for goal in goalsArr {
            if goal == "0" {
                goalsStrArr.append("Weight")
            } else if goal == "1" {
                goalsStrArr.append("Strength")
            } else if goal == "2" {
                goalsStrArr.append("Maintenance")
            }
        }
        
        actualName = name
        self.goalsStr = goalsStrArr.joined(separator: ", ")
        
        let buddyName = name.substring(to: name.index(name.startIndex, offsetBy: 2)) + "***"
        
        self.name.text = buddyName
        self.age.text = ageStr;
        self.freq.text = freqStr;
        self.goals.text = String(goalsArr.count);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func setIsDeleted(){
        isDeleted = true;
    }
    
    func getIsDeleted() -> Bool {
        return isDeleted
    }
}

