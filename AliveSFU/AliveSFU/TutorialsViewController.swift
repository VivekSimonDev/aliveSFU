//
//  TutorialsViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-27.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import Foundation
class TutorialsViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var disclaimerLabel: UILabel!
    var searchActive : Bool = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let dataSourceManager = TutorialExercisesManager()
    var cells = [TutorialExercise]()
    let reuseIdentifier : String = "ExerciseCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        //collectionView.dataSource = self
        //Registering the custom xib cell to be used as a collectionview cell
        collectionView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        //Initially, our data source would be the complete list of exercises
        cells = dataSourceManager.completeExerciseList
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 177, height: 204)
        layout.minimumInteritemSpacing = 10
        collectionView!.collectionViewLayout = layout
        
        collectionView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseCell
        cell.configure(exercise: cells[indexPath.row])
        //cell.backgroundColor = UIColor.black
        return cell
    }
}

// MARK: - Searchbar stuff
extension TutorialsViewController {
    //1
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cells = dataSourceManager.returnExercisesByKeyword(line: searchText)
        collectionView.reloadData()
        
    }
    // hide keyboard when search button clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // hide keyboard when cancel button clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        cells = dataSourceManager.completeExerciseList
        collectionView.reloadData()
        self.searchBar.resignFirstResponder()
        
        //self.myTableView.reloadData()
    }
}

//Class that gets tutorial exercises from stored JSON file
class TutorialExercisesManager {
    var completeExerciseList = [TutorialExercise]() //a complete list of all tutorial exercises parsed from json file
    
    //initializes the complete exercise list
    init() {
        if let jsonData = NSDataAsset(name: "tutorialExercises") {
            let data = jsonData.data
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let array = jsonData as? [Any] {
                for element in array {
                    if let jsonObj = element as? [String: Any] {
                        var newExercise = TutorialExercise()
                        if let name = jsonObj["name"] as? String {
                            newExercise.name = name
                        }
                        if let targetMuscle = jsonObj["targetMuscle"] as? String {
                            newExercise.targetMuscle = targetMuscle
                        }
                        if let equipmentName = jsonObj["equipmentName"] as? String {
                            newExercise.equipmentName = equipmentName
                            
                        }
                        completeExerciseList.append(newExercise)
                    }
                }
            }
        }
    }

    //returns a list of exercisees sorted by the keywords as inputted by the user
    func returnExercisesByKeyword(line : String) -> [TutorialExercise] {
        var newExerciseList = [TutorialExercise]()
        for exercise in completeExerciseList {
            if (exercise.contains(keyword: line))
            {
                newExerciseList.append(exercise)
                
            }
        }
        //return new array
        return newExerciseList
    }
}

//Class defining a tutorial exercise
class TutorialExercise {
    var name: String = ""
    var equipmentName: String = ""
    var targetMuscle : String = ""
    init() {
        
    }
    
    //checking if any of the fields match a user's keyword
    func contains(keyword : String) -> Bool {
        if (name.contains(keyword) || equipmentName.contains(keyword) || targetMuscle.contains(keyword)) {
            return true
        }
        else {
            return false
        }
    }
}
