# AppReviewKit

During the past years I realized that "traditional" prompts (e.g. Appirater) for rating apps do no longer work. The "conversion rates" for these methods are nowadayy nearly at nil.

The following is my alternate solution. It is a subclass of UIView which can basically be put anywhere in your app (e.g. on top of the App Settings). I believe this solution is better, because it does not interrupt the user's experience, instead the user him/herself decides to give feedback (pull instead of push).

![alt tag](http://s14.postimg.org/o2y1jl3sx/App_Review_Kit_Actions_Sketch.png)

This project is a part of my soon to be released online courses on App Store Optimization and Online Marketing for developers. (The part on app ratings will be free: http://appstoreboosting.teachable.com/courses/app-store-reviews.) You can already enroll, please note though that I am still working on the content. If you enroll the course, you will be notified via email as soon as it's ready.

## Usage

#### Install
- Copy the AppReviewKit.swift, Localizable.strings and Image files into your project
- Drop in the ReviewView anywhere in your app (please note - it requires about 100pt in height)
- Set the ReviewViewDelegate and implement the delegate methods
- All set!

#### Customization
##### Styles

![alt tag](http://s13.postimg.org/iaaeljcx3/App_Review_Kit_Styles_Sketch.png)

##### Further Customization
```
reviewView.textColor = UIColor.blackColor()
reviewView.backgroundColor = UIColor.whiteColor()
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
