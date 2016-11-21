//
//  UserProfile.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-19.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

protocol UserProfile {
    
}

class PersonalDetails: UserProfile {
    internal var firstName: String = ""
    internal var lastName: String = ""
    internal var phoneNumber: String? = ""
    internal var gender: Int = -1
    internal var email: String = ""

    required init(firstName: String, lastName: String, gender: Int, phoneNumber: String?, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.gender = gender
    }
}
    
class FitnessDetails: UserProfile {
    internal var heightFeet: Int = -1
    internal var heightInches: Int = -1
    internal var weight: Double = -1
    internal var ageGroup: Int = -1
    internal var fitnessFreq: Int = -1
    internal var personalGoals: String = ""
    
    required init(heightFeet: Int, heightInches: Int, weight: Double, ageGroup: Int, fitnessFreq: Int, personalGoals: String) {
        self.heightFeet = heightFeet
        self.heightInches = heightInches
        self.weight = weight
        self.ageGroup = ageGroup
        self.fitnessFreq = fitnessFreq
        self.personalGoals = personalGoals
    }
}
