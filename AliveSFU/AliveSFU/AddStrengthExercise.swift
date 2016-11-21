//
//  AddStrengthExercise.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Gur Kohli, Gagan Kaur, Vivek Sharma
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class AddStrengthExercise: UIViewController, UITextFieldDelegate {
    
    //Mark: Properties

    @IBOutlet weak var exerciseNameInput: UITextField!
    @IBOutlet weak var setsInput: UITextField!
    @IBOutlet weak var repsInput: UITextField!
    @IBOutlet weak var daysSegment: UISegmentedControl!
    
    @IBOutlet weak var category: UIView!
    @IBOutlet weak var form: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let calendar = NSCalendar.current
        let date = NSDate()
        let currDay = DaysInAWeek(rawValue : calendar.component(.weekday, from: date as Date))!
        daysSegment.selectedSegmentIndex = currDay.index - 1
        
        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        category.layer.borderColor = borderColor
        form.layer.borderColor = borderColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Mark: Action
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        // Check for valid values like max number of characters that can be entered etc.
        // Create a new object
        if (exerciseNameInput.text != "" && setsInput.text != "" && repsInput.text != "") {
            
            //fairly certain that generating the uuid here and passing it to factory is an example of dependency injection and therefore good programming standards
            let uuid = NSUUID().uuidString //generate a unique UUID to use as indexing key for this exercise
            
            //remember to increment daysSegment by 1 because the NSDate indexing for weekdays start at 1
            let newExercise = ExerciseFactory.returnExerciseByCategory(type: ExerciseType.Strength, exerciseName: exerciseNameInput.text!, day: DaysInAWeek(rawValue : daysSegment.selectedSegmentIndex + 1)!, completed: false, id : uuid)

            (newExercise as! StrengthExercise).sets = setsInput.text!
            (newExercise as! StrengthExercise).reps = repsInput.text!
            let result = DataHandler.saveElementToExerciseArray(elem: newExercise)
            if (result == -1) {
                //Handle Error
            }
            DataHandler.getExerciseArray()
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

