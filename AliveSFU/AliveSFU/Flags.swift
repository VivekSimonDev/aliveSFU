//
//  Flags.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-19.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

class Flags {
    var isDataValid: Bool
    var profileExists: Bool?
    var isUserLoggedIn: Bool?
    var enableFitnessBuddy: Bool?
    var enableSleepAnalysis: Bool?
    
    init(isDataValid: Bool, profileExists: Bool?, isUserLoggedIn: Bool?, enableFitnessBuddy: Bool?, enableSleepAnalysis: Bool?) {
        self.isDataValid = isDataValid
        self.profileExists = profileExists
        self.isUserLoggedIn = isUserLoggedIn
        self.enableFitnessBuddy = enableFitnessBuddy
        self.enableSleepAnalysis = enableSleepAnalysis
    }
    
    static var InvalidData = Flags(isDataValid: false, profileExists: false, isUserLoggedIn: false, enableFitnessBuddy: false, enableSleepAnalysis: false)
    
}
