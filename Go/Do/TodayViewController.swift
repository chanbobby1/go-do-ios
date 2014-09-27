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
    var testButton:UIButton
    
    override init() {
        testButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        testButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        testButton = UIButton(frame: CGRectMake(0, 0, 100, 20))
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        testButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        testButton.setTitle("UberUp!", forState: UIControlState.Normal)
        testButton.addTarget(self, action: Selector("uberUpAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.preferredContentSize = CGSizeMake(320, 50);
        self.view.addSubview(testButton)
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
    
    func uberUpAction(sender: UIButton!) {
        openURLSceme("uber://")
    }
    
    func openURLSceme(url: String) {
        openURLSceme(url, {})
    }

    func openURLSceme(url: String, failCallback: () -> ()) {
        let nsurl:NSURL = NSURL(string: url)
        self.extensionContext?.openURL(nsurl, completionHandler: nil)
    }
}
