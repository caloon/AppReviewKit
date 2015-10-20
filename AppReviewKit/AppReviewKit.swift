//
//  AppReviewKit.swift
//  AppReviewKit
//
//  Created by Josef Moser on 20/10/15.
//  Copyright © 2015 Josef Moser. All rights reserved.
//

import UIKit
import MessageUI

// ----------------------------------------------------------------
// - MARK: Enums
enum ReviewViewStyle {
    case Default, Stars
}
enum ReviewViewResponse {
    case Dissatisfied, Satisfied, OneStar, TwoStars, ThreeStars, FourStars, FiveStars
}

// ----------------------------------------------------------------
// - MARK: ReviewViewDelegate
protocol ReviewViewDelegate {
    func userDidRespond(response: ReviewViewResponse!)
    func userDidContactSupport(response: Bool?)
    func userDidReviewApp(response: Bool?) // this only detects if the "rate me" button is clicked
}

// ----------------------------------------------------------------
// - MARK: ReviewView class implementation
class ReviewView: UIView {
    
    // - MARK: Properties
    
    var textColor = UIColor.whiteColor()
    var font = UIFont.systemFontOfSize(15)
    var appID = "284882215" // facebook App ID
    var delegate: ReviewViewDelegate?
    // var backgroundColor inherited from UIView
    
    private var style: ReviewViewStyle?
    private var titleLabel = UILabel()
    private var reviewButtonContainer = UIView()
    
    
    // ----------------------------------------------------------------
    // - MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } // required initializer...

    init(frame: CGRect, style: ReviewViewStyle) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
        self.style = style
        
        // creating the subviews
        if self.style == .Default {
            self.initDefaultView()
        } else if self.style == .Stars {
            self.initStarsView()
        }
    }
    
    func initDefaultView() {
        // title label
        self.titleLabel.frame = CGRectMake(0, (self.frame.height / 2) - 40, self.frame.width, 20)
        self.titleLabel.font = self.font
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = self.textColor
        let titleString =  NSLocalizedString("Do you enjoy using", comment: "")
        let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"]!
        self.titleLabel.text = "\(titleString) \(bundleName)?"
        
        // create review button container
        self.reviewButtonContainer.frame = CGRectMake((self.frame.size.width - 220) / 2 - 5, (self.frame.height / 2), 220, 30)
        for var i = 0; i < 2; i++ {
            let button = UIButton(type: .Custom)
            let x = i * 120
            button.frame = CGRectMake(CGFloat(x), 0, 100, 30)
            
            if i == 0 {
                button.layer.backgroundColor = self.backgroundColor!.CGColor
                button.layer.borderColor = self.textColor.CGColor
                button.setTitleColor(self.textColor, forState: .Normal)
                button.setTitle(NSLocalizedString("Not really", comment: ""), forState: .Normal)
            } else if i == 1 {
                button.layer.backgroundColor = self.textColor.CGColor
                button.layer.borderColor = self.backgroundColor?.CGColor
                button.setTitleColor(self.backgroundColor, forState: .Normal)
                button.setTitle(NSLocalizedString("Yes, indeed", comment: ""), forState: .Normal)
            }
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.titleLabel?.font = self.font
            
            button.tag = i
            button.addTarget(self, action: "didTapResponseButton:", forControlEvents: .TouchUpInside)
            self.reviewButtonContainer.addSubview(button)
        }
        
        // add all views to containerView
        self.addSubview(self.titleLabel)
        self.addSubview(self.reviewButtonContainer)
    }
    
    func initStarsView() {
        // title label
        self.titleLabel.frame = CGRectMake(0, (self.frame.height / 2) - 45, self.frame.width, 20)
        self.titleLabel.font = self.font
        self.titleLabel.textAlignment = .Center
        self.titleLabel.textColor = self.textColor
        let titleString =  NSLocalizedString("How do you like", comment: "")
        let bundleName = NSBundle.mainBundle().infoDictionary!["CFBundleName"]!
        self.titleLabel.text = "\(titleString) \(bundleName)?"
        
        // create review button container
        self.reviewButtonContainer.frame = CGRectMake((self.frame.size.width - 253) / 2, (self.frame.height / 2) - 10, 253, 20)
        for var i = 0; i < 5; i++ {
            let button = UIButton(type: .Custom)
            let x = i * 52
            button.frame = CGRectMake(CGFloat(x), 0, 45, 45)
            button.setImage(UIImage(named: "Settings-RatingStarOutline"), forState: .Normal)
            button.tag = i
            button.addTarget(self, action: "didTapResponseButton:", forControlEvents: .TouchUpInside)
            self.reviewButtonContainer.addSubview(button)
        }
        
        // add all views to containerView
        self.addSubview(self.titleLabel)
        self.addSubview(self.reviewButtonContainer)
    }
    
    
    // ----------------------------------------------------------------
    // MARK: - IBActions
    @IBAction func didTapResponseButton(sender: UIButton) {
        
        print("didTapResponseButton = %i", sender.tag)
        
        if self.style == .Default {
            switch sender.tag {
            case 0:
                self.delegate?.userDidRespond(.Dissatisfied)
            default:
                self.delegate?.userDidRespond(.Satisfied)
            }
        } else if self.style == .Stars {
            
            self.reviewButtonContainer = UIView()
            self.reviewButtonContainer.frame = CGRectMake((self.frame.size.width - 253) / 2, (self.frame.height / 2) - 5, 253, 20)
            // images with filled stars
            for var i = 0; i < sender.tag; i++ {
                let x = i * 52
                let imageView = UIImageView(frame: CGRectMake(CGFloat(x), 0, 45, 45))
                imageView.image = UIImage(named: "Settings-RatingStarFill")
                self.reviewButtonContainer.addSubview(imageView)
            }
            // images with outline stars
            for var i = sender.tag; i < 5; i++ {
                let x = i * 52
                let imageView = UIImageView(frame: CGRectMake(CGFloat(x), 0, 45, 45))
                imageView.image = UIImage(named: "Settings-RatingStarOutline")
                self.reviewButtonContainer.addSubview(imageView)
            }
            
            switch sender.tag {
            case 0:
                self.delegate?.userDidRespond(.OneStar)
            case 1:
                self.delegate?.userDidRespond(.TwoStars)
            case 2:
                self.delegate?.userDidRespond(.ThreeStars)
            case 3:
                self.delegate?.userDidRespond(.FourStars)
            default:
                self.delegate?.userDidRespond(.FiveStars)
            }
        }
        
        
        // create rating alert
        let ratingAlert = UIAlertController(title: NSLocalizedString("Yippie!", comment: ""), message: NSLocalizedString("We're glad that you like <App Name>. Do you mind writing us a short review on the App Store?", comment: ""), preferredStyle: UIAlertControllerStyle.Alert) // tbd - app name
        ratingAlert.addAction(UIAlertAction(title: NSLocalizedString("No, thanks", comment: ""), style: .Default, handler: nil))
        let ratingAction: UIAlertAction = UIAlertAction(title: "Yes, sure", style: .Cancel) { action -> Void in
            let reviewURL = NSString(format: "itms-apps://itunes.apple.com/app/id<APP ID>") // tbd - app id
            UIApplication.sharedApplication().openURL(NSURL(string: reviewURL as String)!)
        }
        ratingAlert.addAction(ratingAction)
        
//        // create alert to send feedback if the user does not like the app
//        let feedbackAlert = UIAlertController(title: NSLocalizedString("Oh!", comment: ""), message: NSLocalizedString("We're sad that you don't like <App Name>. Do you mind sharing with us what we could do better?", comment: ""), preferredStyle: UIAlertControllerStyle.Alert) // tbd - app name
//        feedbackAlert.addAction(UIAlertAction(title: NSLocalizedString("No, thanks", comment: ""), style: .Default, handler: nil))
//        let feedbackAction: UIAlertAction = UIAlertAction(title: "Yes, sure", style: .Cancel) { action -> Void in
//            let mc = MFMailComposeViewController()
//            mc.mailComposeDelegate = self
//            mc.setSubject(NSLocalizedString("Feedback", comment: ""))
//            mc.setToRecipients(["your@email.com"]) // tbd - support email address
//            self.presentViewController(mc, animated: true, completion: nil)
//        }
//        feedbackAlert.addAction(feedbackAction)
//        
//        if sender.tag > 2 {
//            self.presentViewController(ratingAlert, animated: true, completion: nil)
//        } else {
//            self.presentViewController(feedbackAlert, animated: true, completion: nil)
//        }
    }

    
    // ----------------------------------------------------------------
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        // ...
    }
    
}
