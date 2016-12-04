//
//  FirstTimeBuddyFinder.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-30.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class FirstTimeBuddyFinder: UIViewController {
    
    let ERROR_MISSING_ALL_FIELDS = "Missing required fields!"
    let ERROR_MISSING_GENDER = "Missing 'Gender'"
    let ERROR_MISSING_AGE = "Missing 'Age'"
    let ERROR_MISSING_GOALS = "Missing 'Goals'"
    let ERROR_MISSING_FREQUENCY = "Missing 'Frequency'"
    let ERROR_NO_OPTION_SELECTED = "No option selected!"

    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet var ageGroup: [UIButton]!
    @IBOutlet var fitnessFrequency: [UIButton]!
    @IBOutlet var personalGoals: [UIButton]!
    
    @IBOutlet weak var errorAlertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    @IBAction func selectFitnessFrequency(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in fitnessFrequency {
            if (button == sender) {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func selectAgeGroup(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in ageGroup {
            if (button == sender) {
                button.isSelected = true
                
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func selectPersonalGoals(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        sender.isSelected = !sender.isSelected
    }
    
    func validateFields() -> Bool {
        
        errorAlertLabel.text = ERROR_MISSING_ALL_FIELDS
        errorAlertLabel.isHidden = true
        
        //check if gender is selected
        if (gender.selectedSegmentIndex != 0 && gender.selectedSegmentIndex != 1 && gender.selectedSegmentIndex != 2) {
            errorAlertLabel.text = ERROR_MISSING_GENDER
            errorAlertLabel.isHidden = false
            return false
        }
        
        //check if an age group has been selected
        var ageSelected : Bool = false
        for button in ageGroup {
            if (button.isSelected) {
                ageSelected = true
            }
        }
        if (!ageSelected) {
            errorAlertLabel.text = ERROR_MISSING_AGE
            errorAlertLabel.isHidden = false
            return false
        }
        //check if a goal has been selected
        var goalSelected : Bool = false
        for button in personalGoals {
            if (button.isSelected) {
                goalSelected = true
            }
        }
        if (!goalSelected) {
            errorAlertLabel.text = ERROR_MISSING_GOALS
            errorAlertLabel.isHidden = false
            return false
        }
        
        //check if a frequency has been selected
        var freqSelected : Bool = false
        for button in fitnessFrequency {
            if (button.isSelected) {
                freqSelected = true
            }
        }
        if (!freqSelected) {
            errorAlertLabel.text = ERROR_MISSING_FREQUENCY
            errorAlertLabel.isHidden = false
            return false
        }
        
        if (errorAlertLabel.isHidden) {
            return true
        }
        else {
            return false
        }
    }
    @IBAction func saveButton(_ sender: Any) {
        if (validateFields()) {
            
            var age = -1
            for (index, btn) in ageGroup.enumerated() {
                if (btn.isSelected) {
                    age = index
                    break
                }
            }
            
            var fitnessFreq = -1
            for (index, btn) in fitnessFrequency.enumerated() {
                if (btn.isSelected) {
                    fitnessFreq = index
                    break
                }
            }
            
            var goalArr: [String] = []
            for (index, btn) in personalGoals.enumerated() {
                if (btn.isSelected) {
                    goalArr.append(String(index))
                }
            }
            let goals = goalArr.joined(separator: ",")
            
            let buddyDetails = BuddyDetails(ageGroup: age, fitnessFreq: fitnessFreq, personalGoals: goals, gender: gender.selectedSegmentIndex)
            _ = DataHandler.saveBuddyProfile(bd: buddyDetails)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}
