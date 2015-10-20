//
//  ViewController.swift
//  AppReviewKit
//
//  Created by Josef Moser on 18/10/15.
//  Copyright © 2015 Josef Moser. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UITableViewController, ReviewViewDelegate {

    var kUserDidRateApp = NSUserDefaults.standardUserDefaults().boolForKey("kUserDidRateAp")
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    
    // sections & rows
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // section header
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if kUserDidRateApp {
                return 40
            } else {
                return 165
            }
        } else {
            return 40
        }
    }
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel()
        label.frame = CGRectMake(8 * UIScreen.mainScreen().scale, 15, self.view.frame.width - 8 * UIScreen.mainScreen().scale, 20)
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        if kUserDidRateApp {
            label.frame = CGRectMake(0, 20, self.view.frame.width, 15)
            label.text = NSLocalizedString("Settings", comment: "").uppercaseString
            
            let seperatorFrame = CGRectMake(0, label.frame.origin.y + label.frame.size.height + 4.5, self.view.frame.size.width, 0.5)
            let seperator = UIView(frame: seperatorFrame)
            seperator.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
            
            let headerView = UIView()
            headerView.addSubview(label)
            headerView.addSubview(seperator)
            
            return headerView
        } else {
            let reviewView = ReviewView(frame: CGRectMake(0, 0, self.view.frame.size.width, 165), style: .Default)
            reviewView.delegate = self
            return reviewView
        }
    }
    
        
    // cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Your App Settings"
        }
        
        return cell
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    }
    
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - Table view delegate
    
    func userDidRespond(response: ReviewViewResponse!) {
        // advice: log event with Flurry, Fabric, etc.
    }
    
    func userDidContactSupport(response: Bool?) {
        if response == true {
            // open Support Contact sheet
        } else {
            // fade ReviewView out
        }
    }
    
    func userDidReviewApp(response: Bool?) {
        if response == true {
            // open App Store
        } else {
            // fade ReviewView out
        }
    }
    
}
