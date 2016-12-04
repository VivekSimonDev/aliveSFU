//
//  SleepObject.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-12-03.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

protocol SleepProfile {
    
}

class SleepDetails: SleepProfile {

    internal var lastAsleepHours = 0.0
    internal var lastBedHours = 0.0
    internal var lastPercentage = 0.0
    internal var lastTimesWokenUp = 0
    internal var lastTimeTakenFallAsleep = 0.0
    internal var isAsleepDataAvailable = false
    
    init() {
        
    }
    
    required init(asleepHrs: Double, bedHrs: Double, percentageSpentSleeping: Double, noTimesWokenUp: Int, timeTakenFallAsleep: Double, isAsleepDataAvailable: Bool) {
        self.lastAsleepHours = asleepHrs
        self.lastBedHours = bedHrs
        self.lastPercentage = percentageSpentSleeping
        self.lastTimesWokenUp = noTimesWokenUp
        self.lastTimeTakenFallAsleep = timeTakenFallAsleep
        self.isAsleepDataAvailable = isAsleepDataAvailable
    }
}
