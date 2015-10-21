//
//  ViewController.swift
//  AppReviewKit
//
//  Created by Josef Moser on 18/10/15.
//  Copyright © 2015 Josef Moser. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, ReviewViewDelegate, UIAlertViewDelegate {
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        // review view
        let reviewView = ReviewView(frame: CGRectMake(0, 64, self.view.frame.size.width, 165), style: .Default)
        reviewView.delegate = self
        self.view.addSubview(reviewView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - Table view delegate
    
    func userDidRespond(response: ReviewViewResponse!) {
        // advice: log event with Flurry, Fabric, etc.
    }
    
    func userDidContactSupport(response: Bool?) {
        if response == true {
            // open Support Contact sheet
            let alert = UIAlertController(title: "Alert", message: "Open Support Contact sheet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            // fade ReviewView out
        } else {
            // fade ReviewView out
        }
    }
    
    func userDidReviewApp(response: Bool?) {
        if response == true {
            // open App Store
            let alert = UIAlertController(title: "Alert", message: "Open App Store", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            // fade ReviewView out
        } else {
            // fade ReviewView out
        }
    }
    
}
