//
//  PageViewController.swift
//  AliveSFU
//
//  Created by Gur Kohli on 2016-11-14.
//  Copyright © 2016 SimonDevs. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var subpageArray = [UIViewController]()
    var currentIndex = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        let pageControl = UIPageControl.appearance()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 166, green: 25, blue: 46)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        dataSource = self;
        let subpageVC = SubpageViewController()
        subpageArray = subpageVC.getSubpages()
        setViewControllers([subpageArray[1]], direction: .forward, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Disabling swipe left right
        
        /*let index = Int(viewController.restorationIdentifier!)!
        let VC = viewController as! SubpageViewController
        if (index == 1) {
            return nil
        } else if (VC.validateFields()) {
            return VCArray[index-1]
        }*/
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Disabling swipe left right
        
        /*let index = Int(viewController.restorationIdentifier!)!
        let VC = viewController as! SubpageViewController
        if (index == 4) {
            return nil
        } else if (VC.validateFields()) {
            return VCArray[index+1]
        }*/
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subpageArray.count - 1
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    
    func setViewController(index: Int, direction: UIPageViewControllerNavigationDirection) {
        currentIndex = index - 1 // currentIndex is 0-indexed
        setViewControllers([subpageArray[index]], direction: direction, animated: true, completion: nil)
    }
    
    func saveDataToStorage() {
        let personalData = (subpageArray[1] as! Subpage1ViewController).getDataForSave()
        let fitnessData = (subpageArray[2] as! Subpage2ViewController).getDataForSave()
        let enableSleep = (subpageArray[3] as! Subpage3ViewController).getDataForSave()
        let enableFitnessBuddy = (subpageArray[4] as! Subpage4ViewController).getDataForSave()
        
        DataHandler.saveProfile(pd: personalData, fd: fitnessData, enableSleep: enableSleep, enableFitnessBuddy: enableFitnessBuddy)
    }

}
