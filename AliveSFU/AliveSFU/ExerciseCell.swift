//
//  ExerciseCell.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-27.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class ExerciseCell: UICollectionViewCell {
    
    @IBOutlet weak var exerciseThumbnail: UIImageView!
    @IBOutlet weak var exerciseName: UILabel!

    func configure(exercise : TutorialExercise)
    {
        //for the reverse pec dec exercise the step 2 image should be used as the thumbnail
        //adding this hackity hack hack hackz in the code
        if exercise.name == "Reverse Pec Dec" {
            self.exerciseThumbnail.image = UIImage(named: exercise.name + " 2")
        }
        else {
            self.exerciseThumbnail.image = UIImage(named: exercise.name + " 1")
        }
        exerciseName.text = exercise.name
    }
}
