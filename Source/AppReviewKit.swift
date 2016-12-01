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
    case `default`, stars
}
enum ReviewViewDisplay {
    case inline, block
}
enum ReviewViewResponse {
    case dissatisfied, satisfied, oneStar, twoStars, threeStars, fourStars, fiveStars
}

// ----------------------------------------------------------------
// - MARK: ReviewViewDelegate
protocol ReviewViewDelegate : NSObjectProtocol {
    func userDidRespond(_ response: ReviewViewResponse!)
    func userDidContactSupport(_ response: Bool?)
    func userDidReviewApp(_ response: Bool?) // this only detects if the "rate me" button is clicked
}

// ----------------------------------------------------------------
// - MARK: ReviewView class implementation
class ReviewView: UIView {
    
    // - MARK: Properties
    
    var titleColor = UIColor.white
    var titleFont = UIFont.systemFont(ofSize: 15)
    var primaryButtonTextColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    var primaryButtonFillColor = UIColor.white
    var primaryButtonFont = UIFont.systemFont(ofSize: 15)
    var secondaryButtonTextColor = UIColor.white
    var secondaryButtonFillColor = UIColor(red: 59/255.0, green: 89/255.0, blue: 152/255.0, alpha: 1.0)
    var secondaryButtonFont = UIFont.systemFont(ofSize: 15)
    
    weak var delegate: ReviewViewDelegate?
    
    fileprivate var style: ReviewViewStyle = .default
    fileprivate var display: ReviewViewDisplay = .inline
    fileprivate var titleLabel = UILabel()
    fileprivate var reviewButtonContainer = UIView()
    fileprivate var responseButtonContainer = UIView()
    
    
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
        if self.display == .inline {
            
            // set title lable and align subviews
            self.titleLabel.numberOfLines = 2
            self.titleLabel.font = self.titleFont
            self.titleLabel.textAlignment = .center
            self.titleLabel.textColor = self.titleColor
            
            if style == .stars {
                let titleString =  String.localizedStringWithFormat(NSLocalizedString("How do you like %@?", comment: ""), Bundle.main.infoDictionary!["CFBundleName"] as! String)
                self.titleLabel.text = titleString
            } else {
                let titleString =  String.localizedStringWithFormat(NSLocalizedString("Do you enjoy using %@?", comment: ""), Bundle.main.infoDictionary!["CFBundleName"] as! String)
                self.titleLabel.text = titleString
            }
            
            self.alignViews(self.style, sender: "")
        } else if display == .block {
            
            // color dark blue: 50 103 214
            // color blue: 66 133 244
            
            
            
        }
    }
    
    // ----------------------------------------------------------------
    // MARK: - IBActions
    @IBAction func didTapStar(_ sender: UITapGestureRecognizer) {
        
        for i in 0 ..< sender.view!.tag + 1 {
            let x = i * 50
            let view = UIImageView()
            view.frame = CGRect(x: CGFloat(x), y: 2, width: 40, height: 38)
            view.image = UIImage(named: "RatingStarFill")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            view.tintColor = self.titleColor
            self.reviewButtonContainer.addSubview(view)
            self.reviewButtonContainer.bringSubview(toFront: view)
        }
        
        let delayTime = DispatchTime.now() + Double(Int64(200000 * Double(1500))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            switch sender.view!.tag {
                case 0:
                self.delegate?.userDidRespond(.oneStar)
                self.fadeButtonContainerView("support")
                case 1:
                self.delegate?.userDidRespond(.twoStars)
                self.fadeButtonContainerView("support")
                case 2:
                self.delegate?.userDidRespond(.threeStars)
                self.fadeButtonContainerView("rate")
                case 3:
                self.delegate?.userDidRespond(.fourStars)
                self.fadeButtonContainerView("rate")
                default:
                self.delegate?.userDidRespond(.fiveStars)
                self.fadeButtonContainerView("rate")
            }
        }
        
        
    }
    
    @IBAction func didTapResponseButton(_ sender: UIButton) {
        if self.style == .default {
            switch sender.tag {
            case 0:
                self.delegate?.userDidRespond(.dissatisfied)
                self.fadeButtonContainerView("support")
            default:
                self.delegate?.userDidRespond(.satisfied)
                self.fadeButtonContainerView("rate")
            }
        }
    }
    
    @IBAction func didTapSupportButton(_ sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.userDidContactSupport(false)
        } else if sender.tag == 1 {
            self.delegate?.userDidContactSupport(true)
        }
    }
    
    @IBAction func didTapRateButton(_ sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.userDidReviewApp(false)
        } else if sender.tag == 1 {
            self.delegate?.userDidReviewApp(true)
        }
    }
    
    // ----------------------------------------------------------------
    // MARK: - Methods
    func fadeButtonContainerView(_ to: String) {
        
        // transition style
        let transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        transition.duration = 1
        
        // animate title label
        self.titleLabel.layer.add(transition, forKey: kCATransitionFade)
        if to == "support" {
            self.titleLabel.text = NSLocalizedString("Do you mind telling us what we do wrong?", comment: "")
        } else if to == "rate" {
            self.titleLabel.text = NSLocalizedString("Would you rate us on the App Store, then?", comment: "")
        }
        
        self.titleLabel.layer.removeAnimation(forKey: kCATransitionFade)
        
        // animate review button container
        self.reviewButtonContainer.layer.add(transition, forKey: kCATransitionFade)
        for btn in self.reviewButtonContainer.subviews {
            btn.removeFromSuperview()
        }
        for btn in self.responseButtonContainer.subviews {
            btn.removeFromSuperview()
        }
        for i in 0 ..< 2 {
            let button = UIButton(type: .custom)
            let x = i * 120
            if self.style == .default {
                button.frame = CGRect(x: CGFloat(x), y: 0, width: 100, height: 30)
            } else if self.style == .stars {
                button.frame = CGRect(x: CGFloat(x) + 10, y: 5, width: 100, height: 30)
            }
            
            if i == 0 {
                button.layer.backgroundColor = self.primaryButtonFillColor.cgColor
                button.layer.borderColor = self.primaryButtonTextColor.cgColor
                button.setTitleColor(self.primaryButtonTextColor, for: UIControlState())
                button.setTitle(NSLocalizedString("No, thanks", comment: ""), for: UIControlState())
            } else if i == 1 {
                button.layer.backgroundColor = self.secondaryButtonFillColor.cgColor
                button.layer.borderColor = self.secondaryButtonTextColor.cgColor
                button.setTitleColor(self.secondaryButtonTextColor, for: UIControlState())
                button.setTitle(NSLocalizedString("Ok, sure", comment: ""), for: UIControlState())
            }
            
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.titleLabel?.font = self.titleFont
            
            button.tag = i
            if to == "support" {
                button.addTarget(self, action: #selector(ReviewView.didTapSupportButton(_:)), for: .touchUpInside)
            } else if to == "rate" {
                button.addTarget(self, action: #selector(ReviewView.didTapRateButton(_:)), for: .touchUpInside)
            }
            
            self.alignViews(.default, sender: "fadeButtonContainerView")
            
            self.reviewButtonContainer.addSubview(button)
        }
        self.reviewButtonContainer.layer.removeAnimation(forKey: kCATransitionFade)
    }
    
    func alignViews(_ style: ReviewViewStyle, sender: String) {
        
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
        
        self.titleLabel.frame = CGRect(x: (self.frame.size.width - labelWidth) / 2, y: yAxisOriginForTitleLabel, width: labelWidth, height: labelHeight)
        
        if sender != "fadeButtonContainerView" {
            if style == .stars {
                self.reviewButtonContainer.frame = CGRect(x: (self.frame.width - 240) / 2, y: yAxisOriginForReviewButtons, width: 240, height: 38.0)
                
                for i in 0 ..< 5 {
                    let x = i * 50
                    let view = UIImageView()
                    view.frame = CGRect(x: CGFloat(x), y: 2, width: 40, height: 38)
                    view.image = UIImage(named: "RatingStarOutline")!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                    view.tintColor = self.titleColor
                    view.tag = i
                    view.isUserInteractionEnabled = true
                    
                    let gesture = UITapGestureRecognizer(target: self, action: #selector(ReviewView.didTapStar(_:)))
                    view.addGestureRecognizer(gesture)
                    
                    self.reviewButtonContainer.addSubview(view)
                }
            } else {
                self.reviewButtonContainer.frame = CGRect(x: (self.frame.width - 220) / 2, y: yAxisOriginForReviewButtons, width: 220, height: 30.0)
                
                for i in 0 ..< 2 {
                    let button = UIButton(type: .system)
                    let x = i * 120
                    button.frame = CGRect(x: CGFloat(x), y: 0, width: 100, height: 30)
                    
                    if i == 0 {
                        button.layer.backgroundColor = self.primaryButtonFillColor.cgColor
                        button.layer.borderColor = self.primaryButtonTextColor.cgColor
                        button.setTitleColor(self.primaryButtonTextColor, for: UIControlState())
                        button.setTitle(NSLocalizedString("Not really", comment: ""), for: UIControlState())
                    } else if i == 1 {
                        button.layer.backgroundColor = self.secondaryButtonFillColor.cgColor
                        button.layer.borderColor = self.secondaryButtonTextColor.cgColor
                        button.setTitleColor(self.secondaryButtonTextColor, for: UIControlState())
                        button.setTitle(NSLocalizedString("Yes, indeed", comment: ""), for: UIControlState())
                    }
                    
                    button.layer.cornerRadius = 5
                    button.layer.borderWidth = 1
                    button.titleLabel?.font = self.titleFont
                    
                    button.tag = i
                    button.addTarget(self, action: #selector(ReviewView.didTapResponseButton(_:)), for: .touchUpInside)
                    self.reviewButtonContainer.addSubview(button)
                }
            }

        }
        
        // add all views to containerView
        self.addSubview(self.titleLabel)
        self.addSubview(self.reviewButtonContainer)
        
    }
    
    func calculateLabelWidth(_ label:UILabel)->Float{
        if let text = label.text {
            let theLabel = UILabel()
            theLabel.text = text
            theLabel.sizeToFit()
            
            var width = round(theLabel.frame.size.width)
            if width.truncatingRemainder(dividingBy: 2) != 0 {
                width += 1
            }
            
            return Float(width) / Float(self.countLabelLines(label)) + 50
        }
        
        return 0
    }
    
    func calculateLabelHeight(_ aLabel:UILabel)->Float{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat(self.calculateLabelWidth(aLabel)), height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = self.titleFont
        label.text = aLabel.text
        
        label.sizeToFit()
        return Float(label.frame.height)
    }
    
    func countLabelLines(_ label:UILabel)->Int{
        if let text = label.text{
            // cast text to NSString so we can use sizeWithAttributes
            let theText = text as NSString
            //A Paragraph that we use to set the lineBreakMode.
            let paragraph = NSMutableParagraphStyle()
            //Set the lineBreakMode to wordWrapping
            paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
            
            //Calculate the size of your UILabel by using the systemfont and the paragraph we created before. Edit the font and replace it with yours if you use another
            let size = theText.size(attributes: [NSFontAttributeName : self.titleFont, NSParagraphStyleAttributeName : paragraph.copy()])
            
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
    
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        // ...
    }
}



// ----------------------------------------------------------------
// - MARK: Subclass UIButton to enable touches on transparent areas

class MYButton: UIButton {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.frame.contains(point) {
            return self
        } else {
            return nil
        }
    }
    
}

