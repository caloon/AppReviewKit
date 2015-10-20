# AppReviewKit

During the past years I realized that "traditional" prompts for rating apps do no longer work. App users are used to these prompts and close them immediately.

Thus, I developed an alternative solution to prompt your users to review or rate your app on the App Store. It does the following:
- display an app rating view (5 outlined stars) above the app's settings
- once the user taps one of the stars, the stars will be replaced by filled ones and a UIAlert prompt is displayed
- if the user chooses 3-5 stars, the user will be asked to review, otherwise the user will be asked for feedback via email
- the next time the app's settings are loaded, the rating view will no longer be displayed

I believe this solution is better than generic UIAlert prompts because they do not interrupt the user's experience, instead the user him/herself decides to rate the app (pull instead of push).

![alt tag](https://photos-2.dropbox.com/t/2/AADMNPRvAi0lpiwSl3y7Dpix3NKbiw1ET1Yv9s592Y20aw/12/48617349/png/32x32/1/1445176800/0/2/appreviewkit.png/CIWvlxcgASACIAcoAigH/F2A9p66JRt-q_aP6uvbkd0N2fP5gZ2P-KTyRZlcHJxc?size=1024x768&size_mode=2)


This project is a part of my soon to be released online courses on http://appstoreboosting.teachable.com/courses/app-store-reviews. The course will be for free. You can already enroll, please not though that I am still working on the content. If you enroll the course, you will be notified via email as soon as it is ready.

## Usage

#### Install
- Copy the AppReviewKit.swift file into your project
- Set the ReviewViewDelegate

#### Customization
##### Styles
tbd - image

##### Further Customization
```
reviewView.textColor = UIColor.blackColor()
reviewView.font = UIFont.systemFontOfSize(15)
```

#### Delegate
```
func userDidRespond(response: ReviewViewResponse!) {
  // advice: log event with Flurry, Fabric, etc.
  
  // ReviewViewResponses: 
  // .Satisfied / .Dissatisfied (ReviewViewStyle.Default)
  // .OneStar, .TwoStars, etc. (ReviewViewStyle.Stars)
}

func userDidContactSupport(response: Bool?) {
  if response == true {
    // open Support Contact sheet
    // fade ReviewView out
  } else {
    // fade ReviewView out
  }
}

 func userDidReviewApp(response: Bool?) {
  if response == true {
    // open App Store
    // fade ReviewView out
  } else {
    // fade ReviewView out
  }
}
```

## Contribution
- If you'd like to contribute please submit a pull request via GitHub. 
- Speaking a language that is currently not supported by AppReviewKit? Provide us your Localizations ;)

Like AppReviewKit? Get us a beer ;-) 
[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=NVFEEVXQSSM9S)

## License
Feel free to use this source in any of your projects. If you'd like to acknowledge the author, feel free to link to www.caloon.co or www.github.com/caloon
