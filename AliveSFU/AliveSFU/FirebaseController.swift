//
//  firebaseController.swift
//  AliveSFU
//
//  Created by Jim on 2016-12-01.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import Foundation

//Defining all the REST call types
public enum requestType : String {
    case GET = "GET", DELETE = "DELETE", PUT = "PUT", PATCH = "PATCH"
}

class firebaseController {
    let databaseKey : String = "zwUOWHxJ59yCy8xDftAAnHBq0DiBHLIL51KGK9Xq"
    
    //Returns an array of user profiles from database in descending order by how close you match with the weight
    //By the nature of Swift URL async calls, the call to fetch and populate our array will be running on a thread other than the UI thread. This means that if the UI thread tries to access the fetched data before the GET request is completed, we'll just get an empty array. Using dispatch queue, the function asks the callee to input the function that needs to occur when the array is done being populated. Inside that function it will most likely be something similar to setting the tableView datasource as the fetched array data and calling tableView.reloadData()
    
    //The actual fetched array will be returned in the function pointer (closure) you provide to this function
    func returnClosestMatch(weight : Int, function : @escaping ([firebaseProfile]) -> Void) {
        getUsers(weight: weight, function: function) //fetch from firebase database
    }
    
    //fetch all currently stored users from firebase database as an array
    private func getUsers(weight: Int, function : @escaping ([firebaseProfile]) -> Void) {
        let url = URL(string: "https://alivesfu-30553.firebaseio.com/.json?auth=\(databaseKey)")
        var profiles = [firebaseProfile]()
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //check if an error is returned form the server
            if error != nil {
                print(error!)
                return
            }

            
            do {
                let jsonBody = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let body = jsonBody as? [String : Any]
                //parse each user object
                for userProfile in body! {
                    if let data = userProfile.value as? [String : Any] {
                        let newProfile = firebaseProfile()
                        //if any of the below checks fail, continue to the next profile since a user profile is messed up
                        if let devID = data["devID"] as? String {
                            newProfile.devID = devID
                        }
                        else {
                            continue
                        }
                        if let userName = data["userName"] as? String {
                            //omit yourself
                            if userName == DataHandler.getCurrentUser() {
                                continue
                            }
                            newProfile.userName = userName
                        }
                        else {
                            continue
                        }
                        if let hashNum = data["hashNum"] as? String {
                            let num = Int(hashNum)
                            if num != nil {
                                newProfile.hashNum = num!
                            }
                            else {
                                continue
                            }
                        }
                        else {
                            continue
                        }
                        //check if nil and nothing has been added
                        profiles.append(newProfile)
                    }
                    
                }
                if !profiles.isEmpty {
                    //sort array by how closer it is to the inputted weight integer
                    profiles = profiles.sorted(by: {
                        (left: firebaseProfile, right: firebaseProfile) -> Bool in
                        return abs(weight-left.hashNum) < abs(weight-right.hashNum)
                    })
                }
                
            } catch let error {
                print(error)
            }
            
            DispatchQueue.main.async {
                function(profiles)
            }
            }.resume()
    }
    
    //removes a user from firebase database
    func deleteUser(userID: String) {
        var request = URLRequest(url: URL(string : "https://alivesfu-30553.firebaseio.com/\(userID).json?auth=\(databaseKey)")!)
        request.httpMethod = requestType.DELETE.rawValue //making a DELETE request
        //request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    //configureUser() will either edit a user if it exists, or add one if it doesn't exist
    //Use it for both editing or adding a user
    func configureUser(newUser: firebaseProfile) {
        var request = URLRequest(url: URL(string : "https://alivesfu-30553.firebaseio.com/\(newUser.userName).json?auth=\(databaseKey)")!)
        request.httpMethod = requestType.PUT.rawValue //making a PUT request
        let postString = "{\"devID\" : \"\(newUser.devID)\", \"userName\" : \"\(newUser.userName)\", \"hashNum\" : \"\(newUser.hashNum)\"}"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
    //get all requests waiting for this user
    //call this function at startup
    func getRequests(weight: Int, function : @escaping ([firebaseProfile]) -> Void) {
        let username = DataHandler.getCurrentUser()
        if username == nil {
            return
        }
        let url = URL(string: "https://alivesfu-30553.firebaseio.com/" + username! + "/requests.json?auth=\(databaseKey)")
        //skip if the user doesn't have any pending requests
        if url != nil {
        var profiles = [firebaseProfile]()
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            //check if an error is returned from the server
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let jsonBody = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                if let body = jsonBody as? [String : Any] {
                    //parse each user object
                    for userProfile in body {
                        //a request that has been made for this user
                        let request = firebaseProfile()
                        if let username = userProfile.key as? String{
                            request.userName = username
                        }
                        else {
                            continue
                        }
                        
                        if let hashnum = userProfile.value as? String {
                            request.hashNum = Int(hashnum)!
                        }
                        else {
                            continue
                        }
                        profiles.append(request)
                        //DataHandler.addIncomingRequest(req: request)
                    }
                    
                }
                else {
                    //there are no requests for this user
                }
            }
            catch let error {
                    print(error)
            }
            DispatchQueue.main.async {
                function(profiles)
            }
            }.resume()
        }
    }
    
    //send a request to this user
    func sendRequest(user: firebaseProfile) {
        let username = DataHandler.getCurrentUser()
        let num = DataHandler.getHashNum()
        let requrl = URL(string : "https://alivesfu-30553.firebaseio.com/\(user.userName)/requests.json?auth=\(databaseKey)")!
        let postString = "{\"" + username! + "\": \"" + String(num) + "\"}"//"{\"requests\": {\"" + username! + "\": \"from\"}}"
        var request = URLRequest(url: requrl)
        request.httpMethod = requestType.PATCH.rawValue //making a PUT request
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
        }
        task.resume()
        
    }
    
}
