//
//  MyProfileViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-20.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet var height: [UITextField]!
    @IBOutlet var weight: [UITextField]!
    @IBOutlet var ageGroup: [UIButton]!
    @IBOutlet var fitnessFrequency: [UIButton]!
    @IBOutlet var personalGoals: [UIButton]!
    
    @IBOutlet weak var errorAlertLabel: UILabel!
    
    let ERROR_MISSING_ALL_FIELDS = "Missing required fields!"
    let ERROR_MISSING_GENDER = "Missing 'Gender'"
    let ERROR_MISSING_AGE = "Missing 'Age'"
    let ERROR_MISSING_GOALS = "Missing 'Goals'"
    let ERROR_MISSING_FREQUENCY = "Missing 'Frequency'"
    let ERROR_NO_OPTION_SELECTED = "No option selected!"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        phoneNumber.keyboardType = .phonePad
        email.keyboardType = .emailAddress
        for btn in height {
            btn.keyboardType = .decimalPad
        }
        for btn in weight {
            btn.keyboardType = .decimalPad
        }
        
        let pd = DataHandler.getPersonalDetails()
        let fd = DataHandler.getFitnessDetails()
        
        gender.selectedSegmentIndex = pd.gender
        firstName.text = pd.firstName
        lastName.text = pd.lastName
        phoneNumber.text = pd.phoneNumber
        email.text = pd.email
        
        height[0].text = String(fd.heightFeet)
        height[1].text = String(fd.heightInches)
        
        weight[0].text = String(fd.weight)
        let lb = fd.weight * 2.2046
        weight[1].text = String(format: "%.1f", lb)
        
        ageGroup[fd.ageGroup].isSelected = true
        fitnessFrequency[fd.fitnessFreq].isSelected = true
        
        let goals = fd.personalGoals.components(separatedBy: ",")
        if (goals.first != "") {
            for char in goals {
                let index = Int(char)!
                personalGoals[index].isSelected = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        DataHandler.setUserLoggedIn(isLoggedIn: false)
        
        let sb = UIStoryboard(name: "login", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if (validateFields()) {
            let pd = savePersonalDetails()
            let fd = saveFitnessDetails()
            
            DataHandler.updateProfile(pd: pd, fd: fd)
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func saveFitnessDetails() -> FitnessDetails {
        let heightFeet = Int(self.height[0].text!)!
        let heightInches = Int(self.height[1].text!)!
        let weight = Double(self.weight[0].text!)!
        
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
        
        let fd = FitnessDetails(heightFeet: heightFeet, heightInches: heightInches, weight: weight, ageGroup: age, fitnessFreq: fitnessFreq, personalGoals: goals)
        
        return fd
    }
    
    func savePersonalDetails() -> PersonalDetails {
        let pd = PersonalDetails(firstName: firstName.text!, lastName: lastName.text!, gender: gender.selectedSegmentIndex, phoneNumber: phoneNumber.text, email: email.text!)
        return pd
    }
    
    func validateFields() -> Bool {
        
        errorAlertLabel.isHidden = true
        
        //Check if gender is selected
        if (gender.selectedSegmentIndex != 0 && gender.selectedSegmentIndex != 1) {
            errorAlertLabel.text = ERROR_MISSING_GENDER
            errorAlertLabel.isHidden = false
            return false
        }
        //Outline in red the textfields that are missing
        let textViews : [UITextField] = [firstName, lastName, email]
        for textField in textViews {
            if (textField.text?.isEmpty)! {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1
                errorAlertLabel.text = ERROR_MISSING_ALL_FIELDS
                errorAlertLabel.isHidden = false
                
            }
            else {
                textField.layer.borderWidth = 0
            }
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
        
        //Outline in red the textfields that are missing
        let textViews2 : [UITextField] = height + weight
        for textField in textViews2 {
            if (textField.text?.isEmpty)! {
                let myColor : UIColor = UIColor.red
                textField.layer.borderColor = myColor.cgColor
                textField.layer.borderWidth = 1
                errorAlertLabel.isHidden = false
                errorAlertLabel.text = ERROR_MISSING_ALL_FIELDS
            }
            else {
                textField.layer.borderWidth = 0
            }
        }
        if (errorAlertLabel.isHidden) {
            return true
        }
        else {
            return false
        }
    }
    
    @IBAction func selectFitnessFrequency(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        for button in fitnessFrequency {
            if (button == sender) {
                button.isSelected = true
                
                // User has selected this particular fitness frequency.
                // Add/Update this value in the temp variable that will be later saved to local storage
                
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
                
                // User has selected this particular age group.
                // Add/Update this value in the temp variable that will be later saved to local storage
                
            } else {
                button.isSelected = false
            }
        }
    }
    
    @IBAction func selectPersonalGoals(_ sender: UIButton) {
        //Dismiss all the keyboards
        self.view.endEditing(true)
        
        sender.isSelected = !sender.isSelected
        
        for button in personalGoals {
            if (button.isSelected) {
                // This value is selected as a personal goal.
                // Change values in the temp variable that will be later saved to local storage
            }
        }
    }
    
    @IBAction func updateWeight(_ sender: UITextField) {
        if (sender == weight[0]) { // If kg field was updated
            
            // Calculate the lb field
            if (weight[0].text != "") {
                let kg = Double(weight[0].text!)!
                let lb = kg * 2.2046
                weight[1].text = String(format: "%.1f", lb)
            }
            
        } else if (sender == weight[1]) { // If lb field was updated
            
            //Calculate the kg field
            if (weight[1].text != "") {
                let lb = Double(weight[1].text!)!
                let kg = lb / 2.2046
                weight[0].text = String(format: "%.1f", kg)
            }
        }
    }

}
