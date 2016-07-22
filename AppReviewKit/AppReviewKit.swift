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
enum ReviewViewDisplay {
    case Inline, Block
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
    
    var titleColor = UIColor.whiteColor()
    var titleFont = UIFont.systemFontOfSize(15)
    var primaryButtonTextColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    var primaryButtonFillColor = UIColor.whiteColor()
    var primaryButtonFont = UIFont.systemFontOfSize(15)
    var secondaryButtonTextColor = UIColor.whiteColor()
    var secondaryButtonFillColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    var secondaryButtonFont = UIFont.systemFontOfSize(15)
    
    weak var delegate: ReviewViewDelegate?
    
    private var style: ReviewViewStyle = .Default
    private var display: ReviewViewDisplay = .Inline
    private var titleLabel = UILabel()
    private var reviewButtonContainer = UIView()
    private var responseButtonContainer = UIView()
    
    
    // ----------------------------------------------------------------
    // - MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    } // required initializer...

    init(frame: CGRect, style: ReviewViewStyle/*, display: ReviewViewDisplay */) {
        super.init(frame: frame)
        
        self.style = style
       // self.display = display
        self.backgroundColor = self.primaryButtonTextColor
    }
    
    func show () {
        if self.display == .Inline {
            
            // set title lable and align subviews
            self.titleLabel.numberOfLines = 2
            self.titleLabel.font = self.titleFont
            self.titleLabel.textAlignment = .Center
            self.titleLabel.textColor = self.titleColor
            
            if style == .Stars {
                let titleString =  String.localizedStringWithFormat(NSLocalizedString("How do you like %@?", comment: ""), NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String)
                self.titleLabel.text = titleString
            } else {
                let titleString =  String.localizedStringWithFormat(NSLocalizedString("Do you enjoy using %@?", comment: ""), NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String)
                self.titleLabel.text = titleString
            }
            
            self.alignViews(self.style, sender: "")
        } else if display == .Block {
            
            
            
        }
    }
    
    // ----------------------------------------------------------------
    // MARK: - IBActions
    @IBAction func didTapStar(sender: UITapGestureRecognizer) {
        
        for i in 0 ..< sender.view!.tag + 1 {
            let x = i * 50
            let view = UIImageView()
            view.frame = CGRectMake(CGFloat(x), 2, 40, 38)
            view.image = UIImage(named: "RatingStarFill")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            view.tintColor = self.titleColor
            self.reviewButtonContainer.addSubview(view)
            self.reviewButtonContainer.bringSubviewToFront(view)
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(200000 * Double(1500)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            switch sender.view!.tag {
                case 0:
                self.delegate?.userDidRespond(.OneStar)
                self.fadeButtonContainerView("support")
                case 1:
                self.delegate?.userDidRespond(.TwoStars)
                self.fadeButtonContainerView("support")
                case 2:
                self.delegate?.userDidRespond(.ThreeStars)
                self.fadeButtonContainerView("rate")
                case 3:
                self.delegate?.userDidRespond(.FourStars)
                self.fadeButtonContainerView("rate")
                default:
                self.delegate?.userDidRespond(.FiveStars)
                self.fadeButtonContainerView("rate")
            }
        }
        
        
    }
    
    @IBAction func didTapResponseButton(sender: UIButton) {
        if self.style == .Default {
            switch sender.tag {
            case 0:
                self.delegate?.userDidRespond(.Dissatisfied)
                self.fadeButtonContainerView("support")
            default:
                self.delegate?.userDidRespond(.Satisfied)
                self.fadeButtonContainerView("rate")
            }
        }
    }
    
    @IBAction func didTapSupportButton(sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.userDidContactSupport(false)
        } else if sender.tag == 1 {
            self.delegate?.userDidContactSupport(true)
        }
    }
    
    @IBAction func didTapRateButton(sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.userDidReviewApp(false)
        } else if sender.tag == 1 {
            self.delegate?.userDidReviewApp(true)
        }
    }
    
    // ----------------------------------------------------------------
    // MARK: - Methods
    func fadeButtonContainerView(to: String) {
        
        // transition style
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.duration = 1
        
        // animate title label
        self.titleLabel.layer.addAnimation(transition, forKey: kCATransitionFade)
        if to == "support" {
            self.titleLabel.text = NSLocalizedString("Do you mind telling us what we do wrong?", comment: "")
        } else if to == "rate" {
            self.titleLabel.text = NSLocalizedString("Would you rate us on the App Store, then?", comment: "")
        }
        
        self.titleLabel.layer.removeAnimationForKey(kCATransitionFade)
        
        // animate review button container
        self.reviewButtonContainer.layer.addAnimation(transition, forKey: kCATransitionFade)
        for btn in self.reviewButtonContainer.subviews {
            btn.removeFromSuperview()
        }
        for btn in self.responseButtonContainer.subviews {
            btn.removeFromSuperview()
        }
        for i in 0 ..< 2 {
            let button = UIButton(type: .Custom)
            let x = i * 120
            if self.style == .Default {
                button.frame = CGRectMake(CGFloat(x), 0, 100, 30)
            } else if self.style == .Stars {
                button.frame = CGRectMake(CGFloat(x) + 10, 5, 100, 30)
            }
            
            if i == 0 {
                button.layer.backgroundColor = self.primaryButtonFillColor.CGColor
                button.layer.borderColor = self.primaryButtonTextColor.CGColor
                button.setTitleColor(self.primaryButtonTextColor, forState: .Normal)
                button.setTitle(NSLocalizedString("No, thanks", comment: ""), forState: .Normal)
            } else if i == 1 {
                button.layer.backgroundColor = self.secondaryButtonFillColor.CGColor
                button.layer.borderColor = self.secondaryButtonTextColor.CGColor
                button.setTitleColor(self.secondaryButtonTextColor, forState: .Normal)
                button.setTitle(NSLocalizedString("Ok, sure", comment: ""), forState: .Normal)
            }
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.titleLabel?.font = self.titleFont
            
            button.tag = i
            if to == "support" {
                button.addTarget(self, action: #selector(ReviewView.didTapSupportButton(_:)), forControlEvents: .TouchUpInside)
            } else if to == "rate" {
                button.addTarget(self, action: #selector(ReviewView.didTapRateButton(_:)), forControlEvents: .TouchUpInside)
            }
            
            self.alignViews(.Default, sender: "fadeButtonContainerView")
            
            self.reviewButtonContainer.addSubview(button)
        }
        self.reviewButtonContainer.layer.removeAnimationForKey(kCATransitionFade)
    }
    
    func alignViews(style: ReviewViewStyle, sender: String) {
        
        var totalHeight: CGFloat?
        
        let labelHeight = CGFloat(self.calculateLabelHeight(self.titleLabel))
        let labelWidth = CGFloat(self.calculateLabelWidth(self.titleLabel))
        
        totalHeight = labelHeight /* height title label */ + 30.0 /* height buttons */ + 30 /* padding between titlelabel and buttons */ + 20 /* padding top/bottom */
        
        var yAxisOriginForReviewButtons = (self.frame.size.height - totalHeight!) / 2 /* padding top */
        yAxisOriginForReviewButtons += totalHeight!
        yAxisOriginForReviewButtons -= CGFloat(labelHeight) /* height title label */
        yAxisOriginForReviewButtons -= 30 /* paddings */
        
        var yAxisOriginForTitleLabel = (self.frame.size.height - totalHeight!) / 2
        yAxisOriginForTitleLabel += 10 /* padding top */
        
        self.titleLabel.frame = CGRectMake((self.frame.size.width - labelWidth) / 2, yAxisOriginForTitleLabel, labelWidth, labelHeight)
        
        if sender != "fadeButtonContainerView" {
            if style == .Stars {
                self.reviewButtonContainer.frame = CGRectMake((self.frame.width - 240) / 2, yAxisOriginForReviewButtons, 240, 38.0)
                
                for i in 0 ..< 5 {
                    let x = i * 50
                    let view = UIImageView()
                    view.frame = CGRectMake(CGFloat(x), 2, 40, 38)
                    view.image = UIImage(named: "RatingStarOutline")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    view.tintColor = self.titleColor
                    view.tag = i
                    view.userInteractionEnabled = true
                    
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(ReviewView.didTapStar(_:)))
                    view.addGestureRecognizer(gesture)
                    
                    self.reviewButtonContainer.addSubview(view)
                }
            } else {
                self.reviewButtonContainer.frame = CGRectMake((self.frame.width - 220) / 2, yAxisOriginForReviewButtons, 220, 30.0)
                
                for i in 0 ..< 2 {
                    let button = UIButton(type: .System)
                    let x = i * 120
                    button.frame = CGRectMake(CGFloat(x), 0, 100, 30)
                    
                    if i == 0 {
                        button.layer.backgroundColor = self.primaryButtonFillColor.CGColor
                        button.layer.borderColor = self.primaryButtonTextColor.CGColor
                        button.setTitleColor(self.primaryButtonTextColor, forState: .Normal)
                        button.setTitle(NSLocalizedString("Not really", comment: ""), forState: .Normal)
                    } else if i == 1 {
                        button.layer.backgroundColor = self.secondaryButtonFillColor.CGColor
                        button.layer.borderColor = self.secondaryButtonTextColor.CGColor
                        button.setTitleColor(self.secondaryButtonTextColor, forState: .Normal)
                        button.setTitle(NSLocalizedString("Yes, indeed", comment: ""), forState: .Normal)
                    }
                    
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.titleLabel?.font = self.titleFont
                    
                    button.tag = i
                    button.addTarget(self, action: #selector(ReviewView.didTapResponseButton(_:)), forControlEvents: .TouchUpInside)
                    self.reviewButtonContainer.addSubview(button)
                }
            }

        }
        
        // add all views to containerView
        self.addSubview(self.titleLabel)
        self.addSubview(self.reviewButtonContainer)
        
    }
    
    func calculateLabelWidth(label:UILabel)->Float{
        if let text = label.text {
            let theLabel = UILabel()
            theLabel.text = text
            theLabel.sizeToFit()
            
            var width = round(theLabel.frame.size.width)
            if width % 2 != 0 {
                width += 1
            }
            
            return Float(width) / Float(self.countLabelLines(label)) + 50
        }
        
        return 0
    }
    
    func calculateLabelHeight(aLabel:UILabel)->Float{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat(self.calculateLabelWidth(aLabel)), CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.titleFont
        label.text = aLabel.text
        
        label.sizeToFit()
        return Float(label.frame.height)
    }
    
    func countLabelLines(label:UILabel)->Int{
        if let text = label.text{
            // cast text to NSString so we can use sizeWithAttributes
            let theText = text as NSString
            //A Paragraph that we use to set the lineBreakMode.
            let paragraph = NSMutableParagraphStyle()
            //Set the lineBreakMode to wordWrapping
            paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
            
            //Calculate the size of your UILabel by using the systemfont and the paragraph we created before. Edit the font and replace it with yours if you use another
            let size = theText.sizeWithAttributes([NSFontAttributeName : self.titleFont, NSParagraphStyleAttributeName : paragraph.copy()])
            
            if size.width > self.frame.width - 50 {
                return 2
            } else {
                return 1
            }
        }
        
        return 0
    }
    
    // ----------------------------------------------------------------
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        // ...
    }
}



// ----------------------------------------------------------------
// - MARK: Subclass UIButton to enable touches on transparent areas

class MYButton: UIButton {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if CGRectContainsPoint(self.frame, point) {
            return self
        } else {
            return nil
        }
    }
    
}

