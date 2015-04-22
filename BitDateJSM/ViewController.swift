//
//  ViewController.swift
//  BitDateJSM
//
//  Created by Jared Mermey on 3/30/15.
//  Copyright (c) 2015 Jared Mermey. All rights reserved.
//

import UIKit

let pageController = ViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)

class ViewController: UIPageViewController, UIPageViewControllerDataSource {

    let cardsVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as UIViewController
    
    let profileVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileNavController") as UIViewController
    
    let matchesVC: UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("MatchesNavController") as UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.whiteColor()
        self.dataSource = self
        self.setViewControllers([cardsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //helper functions to go to next/previous VC. Somehow is interactinv with UIPageViwControllerDataSource functions
    func goToNextVC(){
        let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers[0] as UIViewController)!
        setViewControllers([nextVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    
    func goToPreviousVC(){
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers[0] as UIViewController)!
        setViewControllers([previousVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
    
    //UIPageViewControllerDataSource functions
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        //if we are on cardsVC then return profileVC
        switch viewController {
            case cardsVC: return profileVC
            case profileVC: return nil
            case matchesVC: return cardsVC
            default: return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        //if we are on profileVC then return cardsVC
        switch viewController {
            case cardsVC: return matchesVC
            case profileVC: return cardsVC
            default: return nil
        }
    }

}

