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

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var uberHomeToWorkButton:UIButton,
        uberWorkToHomeButton:UIButton,
        uberCurrentLocToHomeButton:UIButton;
    
    var grid:UICollectionView?;
    var shortcuts:Array<Shortcut>;
    
//    Stub addresses for now until we have the main app to configure this
    let homeAddress = "1 Market St, San Francisco, CA"
    let workAddress = "200 Market St., San Francsico, CA"
    
    override init() {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        shortcuts = []
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        shortcuts = []
        super.init(coder: aDecoder)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        uberHomeToWorkButton = UIButton()
        uberWorkToHomeButton = UIButton()
        uberCurrentLocToHomeButton = UIButton()
        shortcuts = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.preferredContentSize = CGSizeMake(320, 100)
        
        setupButtons()
        setupShortcuts()
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
        let gridLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        gridLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 5)
        gridLayout.itemSize = CGSize(width: 50, height: 50)
        println(self.view.frame)
        grid = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.width-75, self.view.frame.height), collectionViewLayout: gridLayout)
        grid!.dataSource = self
        grid!.delegate = self
        grid!.registerClass(ShortcutCollectionCell.self, forCellWithReuseIdentifier: "ShortcutCell")
        grid!.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(grid!)
    }
    
//    Add the shortcuts that the user has selected.
//    Stubbing with Uber shortcuts for now
    func setupShortcuts() {
        shortcuts += [
            Shortcut(name: "Home to Work"),
            Shortcut(name: "Work to Home"),
            Shortcut(name: "To Home")
        ]
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
        let nsurl:NSURL = NSURL(string:url)
        self.extensionContext?.openURL(nsurl, completionHandler: { (success:Bool) -> Void in
            if !success {
                failCallback()
            }
        })
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
//    Collection View methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shortcuts.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index:NSInteger = indexPath.row
        let shortcut:Shortcut = shortcuts[index]
        
        var cell = grid!.dequeueReusableCellWithReuseIdentifier("ShortcutCell", forIndexPath: indexPath) as ShortcutCollectionCell
        cell.shortcut = shortcut
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let index:NSInteger = indexPath.row
        let shortcut:Shortcut = shortcuts[index]
        
        switch(shortcut.name) {
        case "Home to Work":
            openUber(from: homeAddress, to: workAddress)
            break
        case "Work to Home":
            openUber(from: workAddress, to: homeAddress)
            break
        case "To Home":
            var destination = homeAddress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            openURLSceme("uber://?action=setPickup&pickup=my_location&dropoff[formatted_address]=\(destination)")
            break
        default:
            break
        }
    }

    func fetchAppIcon(appId: NSString) -> UIImage {
        let urlString = "http://itunes.apple.com/lookup?id=" + appId
        let url = NSURL.URLWithString(urlString)
        let json = NSData(contentsOfURL: url);
       
        let dict : NSDictionary = NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        let results : NSArray = dict.objectForKey("results") as NSArray
        let result : NSDictionary = results.objectAtIndex(0) as NSDictionary
        let imageURLString : NSString = result.objectForKey("artworkUrl100") as NSString
   
        let artworkURL = NSURL.URLWithString(imageURLString)
        var err: NSError?
        var imageData :NSData = NSData.dataWithContentsOfURL(artworkURL, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
       
        return UIImage(data: imageData)
    }
}
