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
        self.view.backgroundColor = UIColor.white
        
        // review view
        let reviewView = ReviewView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 165), style: .stars/*, display: .Inline*/)
        reviewView.delegate = self
        reviewView.backgroundColor = UIColor.green
        reviewView.secondaryButtonTextColor = UIColor.purple
        reviewView.show()
        self.view.addSubview(reviewView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - Review view delegate
    
    func userDidRespond(_ response: ReviewViewResponse!) {
        // advice: log event with Flurry, Fabric, etc.
    }
    
    func userDidContactSupport(_ response: Bool?) {
        if response == true {
            // open Support Contact sheet
            let alert = UIAlertController(title: "Alert", message: "Open Support Contact sheet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            // fade ReviewView out
        } else {
            // fade ReviewView out
        }
    }
    
    func userDidReviewApp(_ response: Bool?) {
        if response == true {
            // open App Store
            let alert = UIAlertController(title: "Alert", message: "Open App Store", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            // fade ReviewView out
        } else {
            // fade ReviewView out
        }
    }
}
