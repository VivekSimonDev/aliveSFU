
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
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var freq: UILabel!
    @IBOutlet weak var goals: UILabel!
    
    var isDeleted: Bool = false
    var uuid: String = ""
    
    let TILE_HEIGHT = CGFloat(20);
    let PADDING = CGFloat(20);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(frame: CGRect, name: String, goals: String, age: String, freq: String) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("SearchTile", owner: self, options: nil);
        self.addSubview(view);    // adding the top level view to the view hierarchy
        
        self.name.text = name;
        self.age.text = age;
        self.freq.text = freq;
        self.goals.text = goals;
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

