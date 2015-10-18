//
//  ViewController.swift
//  AppReviewKit
//
//  Created by Josef Moser on 18/10/15.
//  Copyright © 2015 Josef Moser. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    var kUserDidRateApp = NSUserDefaults.standardUserDefaults().boolForKey("kUserDidRateApp")
    
    // ---------------------------------------------------------------------------------------------------------
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "kUserDidRateApp")
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
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Center
        
        if section == 0 {
            if kUserDidRateApp {
                label.frame = CGRectMake(0, 20, self.view.frame.width, 15)
                label.text = NSLocalizedString("Settings", comment: "").uppercaseString
            } else {
                return self.includeAppRatingHeader()
            }
        }
        
        let seperatorFrame = CGRectMake(0, label.frame.origin.y + label.frame.size.height + 4.5, self.view.frame.size.width, 0.5)
        let seperator = UIView(frame: seperatorFrame)
        seperator.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
        
        let headerView = UIView()
        headerView.addSubview(label)
        headerView.addSubview(seperator)
        
        return headerView
    }
    func includeAppRatingHeader() -> UIView {
        // height 160pt
        
        // title label
        let rateTitle = UILabel()
        rateTitle.frame = CGRectMake(0, 30, self.view.frame.width, 20)
        rateTitle.font = UIFont.systemFontOfSize(14)
        rateTitle.textAlignment = .Center
        rateTitle.textColor = UIColor.grayColor()
        rateTitle.text =  NSLocalizedString("How do you like <App Name>?", comment: "") // tbd - App Name
        
        // create buttons (star icons) and add to containerlet
        let buttonContainer = UIView()
        buttonContainer.frame = CGRectMake((self.view.frame.size.width - 253) / 2, 65, 253, 35)
        
        for var i = 0; i < 5; i++ {
            let button = UIButton(type: .Custom)
            let x = i * 52
            button.frame = CGRectMake(CGFloat(x), 0, 45, 45)
            button.setImage(UIImage(named: "Settings-RatingStarOutline"), forState: .Normal)
            button.tag = i + 1
            button.addTarget(self, action: "tapRatingButton:", forControlEvents: .TouchUpInside)
            buttonContainer.addSubview(button)
        }
        
        // table section header
        let label = UILabel()
        label.frame = CGRectMake(8 * UIScreen.mainScreen().scale, 140, self.view.frame.width - 8 * UIScreen.mainScreen().scale, 20)
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.grayColor()
        label.textAlignment = .Center
        label.text = NSLocalizedString("Settings", comment: "").uppercaseString
        
        // seperator to first settings cell
        let seperatorFrame = CGRectMake(0, buttonContainer.frame.origin.y + buttonContainer.frame.size.height + 4.5, self.view.frame.size.width, 0.5)
        let seperator = UIView(frame: seperatorFrame)
        seperator.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.25)
        
        // add all views to containerView
        let containerView: UIView = UIView()
        containerView.frame = CGRectMake(0, 0, self.view.frame.width, 165)
        containerView.addSubview(rateTitle)
        containerView.addSubview(buttonContainer)
        containerView.addSubview(label)
        containerView.addSubview(seperator)
        
        return containerView
        
    }
    @IBAction func tapRatingButton(sender: UIButton) {
        
        // set NSUserDefault
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "kUserDidRateApp")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // ADVISE - Log ratings using an analytics platform (e.g. Flurry, Fabric)
        
        
        // remove buttons from view and add a new container view
        let buttonContainer = UIView()
        buttonContainer.frame = CGRectMake((self.view.frame.size.width - 253) / 2, 65, 253, 35)
        
        // images with filled stars
        for var i = 0; i < sender.tag; i++ {
            let x = i * 52
            let imageView = UIImageView(frame: CGRectMake(CGFloat(x), 0, 45, 45))
            imageView.image = UIImage(named: "Settings-RatingStarFill")
            buttonContainer.addSubview(imageView)
        }
        
        // images with outline stars
        for var i = sender.tag; i < 5; i++ {
            let x = i * 52
            let imageView = UIImageView(frame: CGRectMake(CGFloat(x), 0, 45, 45))
            imageView.image = UIImage(named: "Settings-RatingStarOutline")
            buttonContainer.addSubview(imageView)
        }
        
        sender.superview!.superview!.addSubview(buttonContainer)
        sender.superview!.removeFromSuperview()
        
        
        // create rating alert
        let ratingAlert = UIAlertController(title: NSLocalizedString("Yippie!", comment: ""), message: NSLocalizedString("We're glad that you like <App Name>. Do you mind writing us a short review on the App Store?", comment: ""), preferredStyle: UIAlertControllerStyle.Alert) // tbd - app name
        ratingAlert.addAction(UIAlertAction(title: NSLocalizedString("No, thanks", comment: ""), style: .Default, handler: nil))
        let ratingAction: UIAlertAction = UIAlertAction(title: "Yes, sure", style: .Cancel) { action -> Void in
            let reviewURL = NSString(format: "itms-apps://itunes.apple.com/app/id<APP ID>") // tbd - app id
            UIApplication.sharedApplication().openURL(NSURL(string: reviewURL as String)!)
        }
        ratingAlert.addAction(ratingAction)
        
        // create alert to send feedback if the user does not like the app
        let feedbackAlert = UIAlertController(title: NSLocalizedString("Oh!", comment: ""), message: NSLocalizedString("We're sad that you don't like <App Name>. Do you mind sharing with us what we could do better?", comment: ""), preferredStyle: UIAlertControllerStyle.Alert) // tbd - app name
        feedbackAlert.addAction(UIAlertAction(title: NSLocalizedString("No, thanks", comment: ""), style: .Default, handler: nil))
        let feedbackAction: UIAlertAction = UIAlertAction(title: "Yes, sure", style: .Cancel) { action -> Void in
            let mc = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(NSLocalizedString("Feedback", comment: ""))
            mc.setToRecipients(["your@email.com"]) // tbd - support email address
            self.presentViewController(mc, animated: true, completion: nil)
        }
        feedbackAlert.addAction(feedbackAction)
        
        if sender.tag > 2 {
            self.presentViewController(ratingAlert, animated: true, completion: nil)
        } else {
            self.presentViewController(feedbackAlert, animated: true, completion: nil)
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
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        // ...
    }
}
