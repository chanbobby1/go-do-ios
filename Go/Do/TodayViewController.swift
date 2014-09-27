//
//  TodayViewController.swift
//  Do
//
//  Created by Bobby on 9/27/14.
//  Copyright (c) 2014 Bobby. All rights reserved.
//

import UIKit
import NotificationCenter

@objc (TodayViewController)

class TodayViewController: UIViewController, NCWidgetProviding {
    var uberHomeToWorkButton:UIButton,
        uberWorkToHomeButton:UIButton,
        uberCurrentLocToHomeButton:UIButton;
    
    override init() {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.preferredContentSize = CGSizeMake(320, 500);
        
        setupButtons()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func setupButtons() {
        uberHomeToWorkButton.frame = CGRectMake(-10, 0, 60, 60)
        uberHomeToWorkButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uberHomeToWorkButton.backgroundColor = UIColor.grayColor()
        uberHomeToWorkButton.setTitle("Home to Work", forState: UIControlState.Normal)
        uberHomeToWorkButton.addTarget(self, action: "uberUpHomeToWorkAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        uberWorkToHomeButton.frame = CGRectMake(-10, 60, 60, 60)
        uberWorkToHomeButton.backgroundColor = UIColor.grayColor()
        uberWorkToHomeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uberWorkToHomeButton.setTitle("Work to Home", forState: UIControlState.Normal)
        uberWorkToHomeButton.addTarget(self, action: "uberUpWorkToHomeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        uberCurrentLocToHomeButton.frame = CGRectMake(-10, 60*2, 60, 60)
        uberCurrentLocToHomeButton.backgroundColor = UIColor.grayColor()
        uberCurrentLocToHomeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uberCurrentLocToHomeButton.setTitle("Home", forState: UIControlState.Normal)
        uberCurrentLocToHomeButton.addTarget(self, action: "uberUpToHomeAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(uberHomeToWorkButton)
        self.view.addSubview(uberWorkToHomeButton)
        self.view.addSubview(uberCurrentLocToHomeButton)
        println("Setup done")
    }
    
    func uberUpHomeToWorkAction(sender: UIButton!) {
        println("TESTS")
        let homeAddress = "1 Market St, San Francisco, CA"
        let workAddress = "200 Market St., San Francsico, CA"
        openUber(from: homeAddress, to: workAddress)
    }
    
    func uberUpWorkToHomeAction(sender: UIButton!) {
        let homeAddress = "1 Market St, San Francisco, CA"
        let workAddress = "200 Market St., San Francsico, CA"
        openUber(from: workAddress, to: homeAddress)
    }
    
    func uberUpToHomeAction(sender: UIButton!) {
        let homeAddress = "1 Market St, San Francisco, CA"
        openURLSceme("uber://?action=setPickup&pickup=my_location&dropoff[formatted_address]=\(homeAddress)")
    }
    
    func openUber(from pickup:String, to destination:String) {
        var pickup = pickup.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        var destination = destination.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        openURLSceme("uber://?action=setPickup&pickup[formatted_address]=\(pickup)&dropoff[formatted_address]=\(destination)", {
            self.showAlert("Missing App", message: "Make sure you have the app installed!")
        })
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle("Okay")
        alert.show()
    }
    
    func openURLSceme(url: String) {
        openURLSceme(url, {})
    }

    func openURLSceme(url: String, failCallback: () -> ()) {
        println("Open url \(url)")
        let nsurl:NSURL = NSURL(string:url)
        self.extensionContext?.openURL(nsurl, completionHandler: { (success:Bool) -> Void in
            if !success {
                failCallback()
            }
        })
    }
}
