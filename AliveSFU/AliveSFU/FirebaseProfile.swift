//
//  firebaseProfile.swift
//  AliveSFU
//
//  Created by Jim on 2016-12-01.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

class firebaseProfile {
    var devID : String = ""
    var userName : String = ""
    var hashNum : Int = 0
    
    init() {
        
    }
    
    init(devID : String, userName : String, hashNum : Int) {
        self.devID = devID
        self.userName = userName
        self.hashNum = hashNum
    }
}

//Overloading operators for comparing hashNums
extension firebaseProfile {
    static func < (left: firebaseProfile, right: firebaseProfile) -> Bool {
        return left.hashNum < right.hashNum
    }
    static func > (left: firebaseProfile, right: firebaseProfile) -> Bool {
        return left.hashNum > right.hashNum
    }
}
