//
//  MyProgressController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-10-26.
//  Developers: Liam O'Shaughnessy, Vivek Sharma, Jim Park, Gagan Kaur, Gur Kohli
//  Copyright © 2016 SimonDevs. All rights reserved.
//  Partial functionality adapted from a third party resource: https://github.com/thefirstnikhil/chartingdemo
//

import UIKit
import CoreData
import JBChart


/* Extensions */

//An extension to UIColor to allow the creation of our own colours using RGB numbers
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
extension Notification.Name {
    static let reload = Notification.Name("reload")
}

// ----------

/* Class: MyProgressController - Handles MyProgress View */

class MyProgressController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource, UIGestureRecognizerDelegate {
    
/* IBOutlets */
    
    @IBOutlet weak var daySelected: UISegmentedControl!
    @IBOutlet weak var barChart: JBBarChartView! //The view the bar chart rests in
    @IBOutlet weak var informationLabel: UILabel! //The label that display info when a bar is tapped
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var exerciseLabel: UIView!

/* Constants */
    
    let CATEGORY_CARDIO_VIEW_TAG = 100
    let CATEGORY_STRENGTH_VIEW_TAG = 200
    let PLACEHOLDER_TAG = 404
    let TILE_HEIGHT = CGFloat(80)
    
    
/* Variables */
    
    var currDay : DaysInAWeek = DaysInAWeek.Sunday
    var panTileOrigin = CGPoint(x: 0, y: 0)
    var chartLegend = ["Sun", "Mon", "Tues", "Wed", "Thurs", "Fri", "Sat"] //x-axis information
    //var chartData = [5, 8, 6, 2, 9, 6, 4]//sample data to display bar graph, replace with actual exercise completion numbers
    var chartData: [Int] = [] //Array that counts completed exercises
    let SFURed = UIColor(red: 166, green: 25, blue: 46)
    let SFUGrey = UIColor(red: 84, green: 88, blue: 90)
    
/* Overriden Functions*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendar = NSCalendar.current
        let date = NSDate()
        currDay = DaysInAWeek(rawValue : calendar.component(.weekday, from: date as Date))!
        
        setupBarChart()
        barChartView(barChart, didSelectBarAt: UInt(currDay.index - 1))
        daySelected.selectedSegmentIndex = currDay.index - 1
        
        /* Disabling screen edges
 
        let leftEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        let rightEdge = UIScreenEdgePanGestureRecognizer(target: self, action: #selector (handleSwipes(_:)))
        leftEdge.edges = .left
        rightEdge.edges = .right
        
        view.addGestureRecognizer(leftEdge)
        view.addGestureRecognizer(rightEdge)*/

        let borderColor = UIColor.init(red: 238, green: 238, blue: 238).cgColor
        contentView.layer.borderColor = borderColor
        barChart.layer.borderColor = borderColor
        exerciseLabel.layer.borderColor = borderColor
        
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        barChart.reloadData()
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(MyProgressController.showChart), userInfo: nil, repeats: false)
        
        let scrollPanGesture = UIPanGestureRecognizer()
        scrollPanGesture.delegate = self
        scrollView.addGestureRecognizer(scrollPanGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        populateStackView()
        updateChartData()
        self.navigationController?.isNavigationBarHidden = true
        
        updateContentViewSize()
    }

    override func viewDidDisappear(_ animated: Bool) {
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = CGFloat(contentView.subviews.count) * (TILE_HEIGHT + 5)
        scrollView.isScrollEnabled = true;
        scrollView.isUserInteractionEnabled = true;
        scrollView.canCancelContentTouches = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
/* IBAction Functions */
    
    @IBAction func dayValueChangeEvent(_ sender: UISegmentedControl) {
        let changedIndex = sender.selectedSegmentIndex
        currDay = DaysInAWeek(rawValue: changedIndex + 1)!
        populateStackView()
        updateContentViewSize()
        
        scrollView.layoutIfNeeded()
    }
    
    @IBAction func showPopup(_ sender: UITapGestureRecognizer) {

        if (sender.view?.tag == CATEGORY_CARDIO_VIEW_TAG) {
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardioTilePopover") as! PopoverCardioTile
            self.addChildViewController(popoverVC)
            popoverVC.view.frame = self.view.frame
            popoverVC.view.tag = 600
            popoverVC.rootViewController = self
            self.view.addSubview(popoverVC.view)
            
            let tile = sender.view as! CardioTileView
            popoverVC.uuid = tile.uuid
            popoverVC.exerciseName.text = tile.exerciseName.text
            popoverVC.time.text = tile.time.text
            popoverVC.speed.text = tile.speed.text
            popoverVC.resistance.text = tile.resistance.text
            popoverVC.didMove(toParentViewController: self)

        } else if (sender.view?.tag == CATEGORY_STRENGTH_VIEW_TAG) {
            let popoverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "strengthTilePopover") as! PopoverStrengthTile
            self.addChildViewController(popoverVC)
            popoverVC.view.frame = self.view.frame
            popoverVC.rootViewController = self
            self.view.addSubview(popoverVC.view)
            
            let tile = sender.view as! StrengthTileView
            popoverVC.uuid = tile.uuid
            popoverVC.exerciseName.text = tile.exerciseName.text
            popoverVC.sets.text = tile.sets.text
            popoverVC.reps.text = tile.reps.text
            popoverVC.didMove(toParentViewController: self)
        }
    }
    
/* Member Functions*/
    
    func tileSlideGesture(_ gesture: UIPanGestureRecognizer) {
        if (gesture.state == .began) {
            self.panTileOrigin = gesture.view!.frame.origin
        }
        if (gesture.state == .began || gesture.state == .changed) {
            let translation = gesture.translation(in: contentView)
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x/2, y: gesture.view!.center.y)
            gesture.setTranslation(CGPoint.zero, in: contentView)
        } else if (gesture.state == .ended) {
            if (self.panTileOrigin.x - gesture.view!.frame.origin.x > 50){
                if (gesture.view?.tag == CATEGORY_CARDIO_VIEW_TAG) {
                    
                    let view = gesture.view as! CardioTileView;
                    setExerciseTileBGColor(isCompleted: true, isCardio: true, cardioView: view, strengthView: nil)
                    DataHandler.markExerciseCompleted(id: view.uuid, value: true)
                    
                } else if (gesture.view?.tag == CATEGORY_STRENGTH_VIEW_TAG) {
                    
                    let view = gesture.view as! StrengthTileView;
                    setExerciseTileBGColor(isCompleted: true, isCardio: false, cardioView: nil, strengthView: view)
                    DataHandler.markExerciseCompleted(id: view.uuid, value: true)
                }
                updateChartData()
                
            } else if (gesture.view!.frame.origin.x - self.panTileOrigin.x > 50) {
                if (gesture.view?.tag == CATEGORY_CARDIO_VIEW_TAG) {
                    
                    let view = gesture.view as! CardioTileView;
                    setExerciseTileBGColor(isCompleted: false, isCardio: true, cardioView: view, strengthView: nil)
                    DataHandler.markExerciseCompleted(id: view.uuid, value: false)
                    
                } else if (gesture.view?.tag == CATEGORY_STRENGTH_VIEW_TAG) {
                    
                    let view = gesture.view as! StrengthTileView;
                    setExerciseTileBGColor(isCompleted: false, isCardio: false, cardioView: nil, strengthView: view)
                    DataHandler.markExerciseCompleted(id: view.uuid, value: false)
                    
                }
                updateChartData()
            }
            UIView.animate(withDuration: 0.1, animations: {gesture.view!.frame.origin = self.panTileOrigin})
        }
    }
    
    func handleSwipes(_ recognizer: UIScreenEdgePanGestureRecognizer){
        if (recognizer.state == .recognized) {
            if(recognizer.edges == .left) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.center.x += self.contentView.frame.width
                })
                //If the page is at Sunday, swiping left should get you to Saturday
                if (currDay == DaysInAWeek.Sunday) {
                    currDay = DaysInAWeek.Saturday
                }
                else {
                    let newDay = currDay.rawValue - 1
                    currDay = DaysInAWeek(rawValue: newDay)!
                }
                daySelected.selectedSegmentIndex = currDay.rawValue - 1 //change segment value as well
                populateStackView()
                contentView.center.x -= contentView.frame.width
            }
            if(recognizer.edges == .right) {
                UIView.animate(withDuration: 0.5, animations: {
                    self.contentView.center.x -= self.contentView.frame.width
                })
                //If the page is at Saturday, swiping right should get you to Sunday
                if (currDay == DaysInAWeek.Saturday) {
                    currDay = DaysInAWeek.Sunday
                }
                else {
                    let newDay = currDay.rawValue + 1
                    currDay = DaysInAWeek(rawValue: newDay)!
                }
                daySelected.selectedSegmentIndex = currDay.rawValue - 1 //change segment value as well
                populateStackView()
                contentView.center.x += contentView.frame.width
            }
            //Recenter contentview since it changed from swiping
        }
    }
    
    //Function that handles the reloading of My Progress page when something is updated from another view
    //e.g. when a tile is changed, this function is called to update the changed tiles and the graphs
    func handleReloading()
    {
        populateStackView()
        updateChartData()
        updateContentViewSize()
    }
    
    //Function for populating the exercise tiles
    func populateStackView() {
        //since the view is now changed, get rid of all preexisting subviews
        for view in contentView.subviews {
            view.removeFromSuperview()
        }
        //Populate Exercise Tiles
        let exerciseArray = DataHandler.getExerciseArray()
        
        var currDayExerCount = 0;
        for elem in exerciseArray {
            
            let frame = CGRect(x: 5, y: 5 + CGFloat(contentView.subviews.count) * (TILE_HEIGHT + 5), width: contentView.bounds.width, height: TILE_HEIGHT)
            
            //Only grab exercises corresponding to the current day to be displayed
            if (elem.day == currDay)
            {
                if (elem.getType() == .Cardio) {
                    let tile = CardioTileView(frame: frame, name: elem.exerciseName, time: (elem as! CardioExercise).time, speed: (elem as! CardioExercise).speed, resistance: (elem as! CardioExercise).resistance)
                    tile.uuid = elem.id

                    configureTiles(isCardio: true, cardioTile: tile, strengthTile: nil)
                
                    contentView.addSubview(tile)
                } else {
                    let tile = StrengthTileView(frame: frame, name: elem.exerciseName, sets: (elem as! StrengthExercise).sets, reps: (elem as! StrengthExercise).reps)
                    tile.uuid = elem.id

                    configureTiles(isCardio: false, cardioTile: nil, strengthTile: tile)

                    contentView.addSubview(tile)
                }
                currDayExerCount += 1;
            }
        }
        if (currDayExerCount == 0) {
            //Display Placeholder Exercise Tile
            let placeholder = UIImageView(image: UIImage(named: "noExercisePlaceholder"))
            placeholder.tag = PLACEHOLDER_TAG
            placeholder.frame = CGRect(x: 0, y: -40, width: self.view.frame.width - 40, height: 500)
            contentView.addSubview(placeholder)
        }
    }
    func setupBarChart()
    {
        chartData = DataHandler.countCompletion()
        barChart.backgroundColor = UIColor.white
        barChart.delegate = self
        barChart.dataSource = self
        barChart.minimumValue = 0
        barChart.maximumValue = CGFloat(chartData.max()!) //Max value of a bar in the graph is the max value from the data array.
        //The height of each bar is relative to this value
        
        //NOTE: footer and header created below reduce size/space of the actual bar graph.
        
        //Creating a footer with appropriate Day labels. Spacing is hard coded unfortunately
        let footer = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        footer.textColor = UIColor.black
        footer.text = " \(chartLegend[0])     \(chartLegend[1])     \(chartLegend[2])     \(chartLegend[3])    \(chartLegend[4])     \(chartLegend[5])        \(chartLegend[6])"
        footer.textAlignment = NSTextAlignment.left
        
        //Creating a header.
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: barChart.frame.width, height: 16))
        header.textColor = UIColor.black
        header.text = "Workout Completion Chart"
        header.textAlignment = NSTextAlignment.center
        
        barChart.footerView = footer
        barChart.headerView = header
        barChart.reloadData()
        barChart.setState(.collapsed, animated: false)
    }
    
    func hideChart() {
        barChart.setState(.collapsed, animated: true)
    }
    
    func showChart() {
        barChart.setState(.expanded, animated: true)
    }
    
    
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        return CGFloat(chartData[Int(index)])
    }
    
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        return SFURed
        
    }
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        let data = chartData[Int(index)]
        let key = chartLegend[Int(index)]
        
        informationLabel.text = "Workouts completed on \(key): \(data)"
        //Maybe change the bar graphs to a percentage, so that if all workouts are completed on that day, the bar is a maximum height.
    }
    func updateChartData() {
        chartData = DataHandler.countCompletion()
        barChart.reloadData()
    }
    
    func updateContentViewSize() {
        if (contentView.subviews.count == 1 && contentView.subviews.first?.tag == PLACEHOLDER_TAG) {
            contentViewHeight.constant = scrollView.frame.height
        } else {
            contentViewHeight.constant = CGFloat(contentView.subviews.count) * (TILE_HEIGHT + 5)
        }
    }
    
    func setExerciseTileBGColor(isCompleted: Bool, isCardio: Bool, cardioView: CardioTileView?, strengthView: StrengthTileView?) {
        if (isCardio) {
            if (isCompleted) {
                cardioView!.mainView.backgroundColor = SFURed.withAlphaComponent(0.5)
                cardioView!.checkmark.isHidden = false
            } else {
                cardioView!.mainView.backgroundColor = SFURed
                cardioView!.checkmark.isHidden = true
            }
        } else {
            if (isCompleted) {
                strengthView!.mainView.backgroundColor = SFURed.withAlphaComponent(0.5)
                strengthView!.checkmark.isHidden = false
            } else {
                strengthView!.mainView.backgroundColor = SFURed
                strengthView!.checkmark.isHidden = true
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    func configureTiles(isCardio: Bool, cardioTile: CardioTileView?, strengthTile: StrengthTileView?) {
        if (isCardio) {
            cardioTile!.tag = CATEGORY_CARDIO_VIEW_TAG
            let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
            cardioTile!.addGestureRecognizer(tapGesture)
            
            let slideGesture = UIPanGestureRecognizer(target: self, action: #selector (self.tileSlideGesture(_:)))
            slideGesture.delegate = self
            cardioTile!.addGestureRecognizer(slideGesture)
            
            if (DataHandler.isExerciseCompleted(id: cardioTile!.uuid)) {
                setExerciseTileBGColor(isCompleted: true, isCardio: true, cardioView: cardioTile, strengthView: nil)
            }
        } else {

            strengthTile!.tag = CATEGORY_STRENGTH_VIEW_TAG
            let tapGesture = UITapGestureRecognizer(target: self, action:  #selector (self.showPopup(_:)))
            strengthTile!.addGestureRecognizer(tapGesture)
            
            let slideGesture = UIPanGestureRecognizer(target: self, action: #selector (self.tileSlideGesture(_:)))
            slideGesture.delegate = self
            strengthTile!.addGestureRecognizer(slideGesture)
            
            if (DataHandler.isExerciseCompleted(id: strengthTile!.uuid)) {
                setExerciseTileBGColor(isCompleted: true, isCardio: false, cardioView: nil, strengthView: strengthTile)
            }
        }
    }
}

