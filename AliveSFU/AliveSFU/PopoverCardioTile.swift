//
//  PopoverCardioTile.swift
//  AliveSFU
//  Created by Gur Kohli on 2016-11-05.
//  Developers: Gagan Kaur
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreData

class PopoverCardioTile: UIViewController, UITextFieldDelegate {
    
    var currCardioExercise : CardioExercise? = nil
    var uuid : String = ""
    @IBOutlet weak var exerciseName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var speed: UILabel!
    @IBOutlet weak var resistance: UILabel!
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var speedTextField: UITextField!
    @IBOutlet weak var resistanceTextField: UITextField!
    
    @IBOutlet weak var editableButtons: UIStackView!
    @IBOutlet weak var changeExerButton: UIButton!
    
    @IBOutlet weak var staticRows: UIStackView!
    @IBOutlet weak var editableRows: UIStackView!
    
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var rootViewController: MyProgressController? //TODO: find something more elegant
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        showEditable(yes: false)
        self.showAnimate()
        
        //NotificationCenter.default.post(name: .reload, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changeExercise(_ sender: AnyObject) {
            exerciseNameTextField.text = exerciseName.text
        timeTextField.text = time.text
        speedTextField.text = speed.text
        resistanceTextField.text = resistance.text
        showEditable(yes: true)
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimate()
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        _ = DataHandler.deleteElementFromExerciseArray(id: uuid)

        removeAnimate()
        
    }
    
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        showEditable(yes: false)
    }
    
   
    @IBAction func saveButton(_ sender: UIButton) {
    
        //The day field and completed field are not necessary for the function, so we're passing in arbitrary numbers
        let newExerciseObject = CardioExercise(exerciseName: exerciseNameTextField.text!, day: .Sunday, completed: false, id : uuid)
        newExerciseObject.time = timeTextField.text!
        newExerciseObject.speed = speedTextField.text!
        newExerciseObject.resistance = resistanceTextField.text!
        let _ = DataHandler.saveExerciseChanges(elem: newExerciseObject)

        removeAnimate()
        
        
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
                    self.rootViewController!.handleReloading() //reload My Progress page
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
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
