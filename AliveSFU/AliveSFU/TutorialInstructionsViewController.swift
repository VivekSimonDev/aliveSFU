//
//  TutorialInstructionsViewController.swift
//  AliveSFU
//
//  Created by Jim on 2016-11-30.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class TutorialInstructionsViewController: UIViewController {

    @IBOutlet weak var targetMuscleLabel: UILabel!
    @IBOutlet weak var equipmentNameLabel: UILabel!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIView!

    var exercise = TutorialExercise()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add SFU Red color to border
        let borderColor = UIColor.init(red: 166, green: 25, blue: 46).cgColor
        labelView.layer.borderColor = borderColor
        
        configurePage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //Configures the size of the instructions page and update labels accordingly
    func configurePage() {
        equipmentNameLabel.text = exercise.equipmentName
        exerciseNameLabel.text = exercise.name
        targetMuscleLabel.text = exercise.targetMuscle
        
        //get all instruction images
        var allImagesFetched = false
        var instructionIndex = 0
        while !allImagesFetched {
            let image = UIImage(named: exercise.name + " " + String(instructionIndex+1))
            //the instruction images are stored as "exercisename (step index)"
            //I basically just loop and add 1 to the step index to add to the view, and break out of the loop when an image is not found
            if image != nil {
                let sizeMultiplier = self.view.frame.width / (image?.size.width)!
                //some UI positioning hocus pocus
                let frame = CGRect(x: 0, y: (5 + (image?.size.height)!*sizeMultiplier) * CGFloat(instructionIndex), width: self.view.frame.width, height: (image?.size.height)!*sizeMultiplier)
                let imageView = UIImageView(frame: frame)
                imageView.image = image
                scrollView.addSubview(imageView)
                instructionIndex += 1
                scrollView.contentSize.height += frame.size.height

                }
            else {
                allImagesFetched = true
            }
            
        }
        
        //add text instructions
        for step in exercise.steps {
            let textView = UITextView(frame: CGRect(x: -5, y: scrollView.contentSize.height + 5, width: self.view.frame.width-20, height: 75))
            textView.text = step
            //textView.contentMode = UIViewContentMode.scaleToFill
            textView.font = UIFont(name: "Helvetica", size: CGFloat(16))
            scrollView.addSubview(textView)
            scrollView.contentSize.height += textView.frame.size.height
        }
        
        //if there are extra steps and images specified
        for imageName in exercise.extraImages {
            let image = UIImage(named: imageName)
            let sizeMultiplier = self.view.frame.width / (image?.size.width)!
            let frame = CGRect(x: 0, y: 5 + scrollView.contentSize.height, width: self.view.frame.width, height: (image?.size.height)!*sizeMultiplier)
            let imageView = UIImageView(frame: frame)
            //imageView.contentMode = UIViewContentMode.scaleAspectFit
            imageView.image = image
            scrollView.addSubview(imageView)
            instructionIndex += 1
            scrollView.contentSize.height += frame.size.height + 5
        }
        for step in exercise.extraSteps {
            let textView = UITextView(frame: CGRect(x: -5, y: scrollView.contentSize.height + 5, width: self.view.frame.width-20, height: 70))
            textView.text = step
            //textView.contentMode = UIViewContentMode.scaleToFill
            textView.font = UIFont(name: "Helvetica", size: CGFloat(16))
            scrollView.addSubview(textView)
            scrollView.contentSize.height += textView.frame.size.height
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
