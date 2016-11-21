//
//  AddNewExerciseController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class AddNewExerciseController: UIViewController {
    @IBOutlet weak var category: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        category.layer.borderColor = borderColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

