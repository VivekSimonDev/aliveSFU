//
//  PopoverStrengthTile.swift
//  AliveSFU
//
//  Created by Liam O'Shaughnessy on 2016-10-28.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class PopoverStrengthTile: UIViewController {

    @IBOutlet weak var reps: UILabel!
    @IBOutlet weak var sets: UILabel!
    @IBOutlet weak var exerciseName: UILabel!
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    @IBOutlet weak var editableRows: UIStackView!
    @IBOutlet weak var staticRows: UIStackView!
    @IBOutlet weak var changeExerButton: UIButton!
    @IBOutlet weak var editableButtons: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        showEditable(yes: false)
        self.showAnimate()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func changeExercise(_ sender: AnyObject) {
        exerciseNameTextField.text = exerciseName.text
        setsTextField.text = sets.text
        repsTextField.text = reps.text
        showEditable(yes: true)
    }
    
    
    @IBAction func deleteButton(_ sender: AnyObject) {
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        showEditable(yes: false)
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
    }

    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    } 
    
    
    func removeAnimate()
    {
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
    
    func showEditable(yes: Bool) {
        exerciseName.isHidden = yes
        staticRows.isHidden = yes
        changeExerButton.isHidden = yes
        
        editableRows.isHidden = !yes;
        exerciseNameTextField.isHidden = !yes;
        editableButtons.isHidden = !yes;
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