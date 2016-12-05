//
//  CardioTileView.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-01.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class CardioTileView: UIView {
    
    var uuid : String = ""
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var resistance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var checkmark: UIImageView!

    let TILE_HEIGHT = CGFloat(20);
    let PADDING = CGFloat(20);

    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    init(frame: CGRect, name: String, time: String, speed: String, resistance: String) {
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("CardioTileViewUI", owner: self, options: nil);
        self.addSubview(view);    // adding the top level view to the view hierarchy
        
        let origImage = UIImage(named: "Checkmark");
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        checkmark.image = tintedImage
        checkmark.isHidden = true
        
        self.exerciseName.text = name;
        self.speed.text = speed;
        self.resistance.text = resistance;
        self.time.text = time;
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
}
