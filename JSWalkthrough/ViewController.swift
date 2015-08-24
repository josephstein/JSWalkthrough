//
//  ViewController.swift
//  JSWalkthrough
//
//  Created by Joseph Stein on 6/9/15.
//  Copyright (c) 2015 Joseph Stein. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  
  @IBOutlet var skipTitleTextField : UITextField!
  @IBOutlet var doneTitleTextField : UITextField!

  // MARK: - Action Methods

  @IBAction func tappedLaunchButton() {
    let storyboard = UIStoryboard(name: "WalkthroughStoryboard", bundle: nil)
    if let walkthroughViewController = storyboard.instantiateInitialViewController() as? JSWalkthroughViewController {
      walkthroughViewController.storyboardIdentifiers = ["FirstViewController", "SecondViewController", "ThirdViewController", "FourthViewController"]
      walkthroughViewController.doneButtonTitle = self.doneTitleTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      walkthroughViewController.skipButtonTitle = self.skipTitleTextField.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      walkthroughViewController.dismissBlock = {
        self.dismissViewControllerAnimated(true, completion: nil)
      }
      
      let navigationController = UINavigationController(rootViewController: walkthroughViewController)
      self.presentViewController(navigationController, animated: true, completion: nil)
    }
  }
}

