//
//  StrengthTileView.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-03.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class StrengthTileView: UIView {
    
    var uuid : String = ""
    @IBOutlet var view: UIView!

    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    let TILE_HEIGHT = CGFloat(20);
    let PADDING = CGFloat(20);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(frame: CGRect, name: String, sets: String, reps: String) {
        super.init(frame:frame)
        
        Bundle.main.loadNibNamed("StrengthTileViewUI", owner: self, options: nil);
        self.addSubview(view);    // adding the top level view to the view hierarchy
        
        self.exerciseName.text = name;
        self.sets.text = sets;
        self.reps.text = reps;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
}
