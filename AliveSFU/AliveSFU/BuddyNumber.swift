//
//  BuddyNumber.swift
//  AliveSFU
//
//  Created by Liam O'Shaughnessy on 2016-12-01.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

class BuddyNumber
{
    let STRENGTH = "Strength"
    let WEIGHT = "Weight Loss"
    let MAINTENANCE = "Maintenance"
    let GEN_WEIGHT = 10000
    let PER_WEIGHT = 1000
    let AGE_WEIGHT = 100
    let FRE_WEIGHT = 10
    
    func fieldToHash(profile: BuddyProfile) -> Int{
        var id : Int = 0 //Buddy Number
        
        let bd = DataHandler.getBuddyDetails()
        let age = bd.ageGroup
        let gen = bd.gender
        let fre = bd.fitnessFreq
        let per = bd.personalGoals.components(separatedBy: ",")
        
        for element in per{ //Need to loop through all the goals selected
            if element == WEIGHT{
                id += 1*PER_WEIGHT
            }
            if(element == STRENGTH){
                id += 2000
            }
            if(element == MAINTENANCE){
                id += 4000
            }
        }
        id += (gen+1)*GEN_WEIGHT //Adding the rest of the weights
        id += (age+1)*AGE_WEIGHT
        id += (fre+1)*FRE_WEIGHT
        
        return id
    }
    func hashToField(id: Int) -> BuddyProfile{
        let profile = BuddyDetails(ageGroup: -1, fitnessFreq: -1, personalGoals: "", gender: -1)
        
        profile.gender = (id / GEN_WEIGHT)-1
        
        let per = (id % GEN_WEIGHT) / PER_WEIGHT
        switch per{
        case 7:
            profile.personalGoals = "Weight Loss,Strength,Maintenance"
        case 6:
            profile.personalGoals = "Strength,Maintenance"
        case 5:
            profile.personalGoals = "Weight Loss,Maintenance"
        case 4:
            profile.personalGoals = "Maintenance"
        case 3:
            profile.personalGoals = "Weight Loss,Strength"
        case 2:
            profile.personalGoals = "Strength"
        case 1:
            profile.personalGoals = "Weight Loss"
        default:
            profile.personalGoals = ""
        }
        
        let age = (id % PER_WEIGHT) / AGE_WEIGHT
        profile.ageGroup = age-1
        
        let fre = (id % AGE_WEIGHT) / FRE_WEIGHT
        profile.fitnessFreq = fre-1
        
        return profile
    }
    
}

