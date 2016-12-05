//
//  HomePageController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit
import CoreMotion

class HomePageController: UIViewController {

    @IBOutlet weak var stepCount: UILabel!
    @IBOutlet weak var todaySleep: UILabel!
    @IBOutlet weak var bmiCount: UILabel!
    @IBOutlet weak var bmrCount: UILabel!

   // let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    let calendar = NSCalendar.current

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        
        updateFields()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateFields() {

        let calendar = NSCalendar.current
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        comps.hour = 0
        comps.minute = 0
        comps.second = 0
        let midnight = calendar.date(from: comps)!
        self.stepCount.text = "0"
        if(CMPedometer.isStepCountingAvailable()){
            self.pedoMeter.startUpdates(from: midnight) { (data: CMPedometerData?, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        self.stepCount.text = "\(data!.numberOfSteps)"
                    }
                })
            }
        }

        //bmi count
        let pd = DataHandler.getPersonalDetails()
        let fd = DataHandler.getFitnessDetails()

        var bmiCountResult: Double = 0

        let weight = fd.weight //weight in kg
        var totalHeight = Double((fd.heightFeet * 12) + fd.heightInches)

        totalHeight = totalHeight * 0.025 //height in inches * 0.025
        totalHeight = totalHeight * totalHeight

        bmiCountResult = (weight/totalHeight)

        self.bmiCount.text = NSString(format: "%.2f", bmiCountResult) as String

        //bmr count
        //For men: BMR = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (years) + 5
        //For women: BMR = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (years) – 161
        totalHeight = Double((fd.heightFeet * 12) + fd.heightInches) // Total height in inches
        var bmrCountResult: Double = 0
        let heightCm: Double = totalHeight * 2.54
        let ageGroup: Int = fd.ageGroup
        let gender: Int = pd.gender
        var age: Int = 0

        //find average group age
        switch ageGroup {
            case 0 : age = 18 //ageGroup: 17-20
            case 1 : age = 21 //ageGroup: 20-22
            case 2 : age = 23 //ageGroup: 22-25
            case 3 : age = 27 //ageGroup: 25-30
            default : age = 30 //ageGroup: 30+
        }

        let temp1 = Double(10 * weight)
        let temp2 = Double(6.25 * heightCm)
        let temp3 = Double(5 * age)
        if (gender == 1) //Female
        {
            bmrCountResult = temp1 + temp2 - temp3 - 161
        }
        else //Male
        {
            bmrCountResult = temp1 + temp2 - temp3 + 5
        }
        self.bmrCount.text = NSString(format: "%.2f", bmrCountResult) as String

        //today's sleep
        let weekSleep = DataHandler.getLastSleepAnalysisData().lastAsleepHours
        self.todaySleep.text = hourToString(hour: weekSleep)
    }
    
    func hourToString(hour:Double) -> String {
        let hours = Int(floor(hour))
        let mins = Int(floor(hour * 60).truncatingRemainder(dividingBy: 60))
        let secs = Int(floor(hour * 3600).truncatingRemainder(dividingBy: 60))
        
        return String(format:"%d:%02d:%02d", hours, mins, secs)
    }
}

