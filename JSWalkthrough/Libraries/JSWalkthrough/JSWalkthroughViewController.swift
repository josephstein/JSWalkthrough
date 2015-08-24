//
//  JSWalkthroughViewController.swift
//  JSWalkthrough
//
//  Created by Joseph Stein on 6/9/15.
//  Copyright (c) 2015 Joseph Stein. All rights reserved.
//

import UIKit

/// A convenience class that will stitch together various view controllers for a walkthrough user flow
class JSWalkthroughViewController : UIViewController, UIScrollViewDelegate {
  
  /// If set, will hide the applications status bar
  var applicationStatusBarHidden: Bool = true {
    didSet {
      assert(!self.isViewLoaded(), "property must be set before view is loaded")
    }
  }
  
  /// The current page, shown by the page control
  var currentPageNumber: Int {
    return Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
  }
  
  /// Keeps track of page to scroll to after device rotation
  private var lastCurrentPageNumber: Int = 0
  
  /// Called when the user taps the done button.
  ///
  /// This is a required property.
  var dismissBlock: dispatch_block_t?
  
  /// The title of the done button
  var doneButtonTitle: String = "Get Started"
  
  /// The title of the skip button. If `nil`, the button will be hidden until the last screen
  var skipButtonTitle: String?
  
  /// The `Storyboard ID`'s of the view controllers to be included in the walkthrough.
  /// The index of the identifiers correlates to its position. There must be at least
  /// three identifiers supplied.
  ///
  /// This is a required property.
  var storyboardIdentifiers: [String]?
  
  /// The view controllers of the view controllers to be included in the walkthrough
  private var walkthroughViewControllers: [UIViewController]?
  
  @IBOutlet private var actionButton: UIButton!
  @IBOutlet private var actionButtonWidthConstraint: NSLayoutConstraint!
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var scrollView: UIScrollView!
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    assert(self.dismissBlock != nil, "required property 'completionBlock' not set")
    assert(self.storyboard != nil, "required property 'storyboard' not set")
    assert(self.storyboardIdentifiers != nil, "required property 'storyboardIdentifiers' not set")
    assert(self.storyboardIdentifiers?.count >= 3, "there must be at least 3 storyboard identifiers")
    
    self.navigationController?.navigationBar.hidden = true
    self.scrollView.showsHorizontalScrollIndicator = false
    
    setupScrollView()
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    
    var skipTextWidth: CGFloat = 0.0
    var doneTextWidth: CGFloat = 0.0
    
    let attributes = [NSFontAttributeName: self.actionButton.titleLabel!.font]
    let buttonSize = CGSizeMake(CGFloat.max, CGRectGetHeight(self.actionButton.bounds))
    let drawingOptions = NSStringDrawingOptions.allZeros
    let padding: CGFloat = 30.0
    let maxButtonWidth: CGFloat = CGRectGetWidth(self.view.bounds) - padding*2
    
    if let skipButtonTitle = self.skipButtonTitle {
      let skipButtonTitle = NSString(string: skipButtonTitle)
      skipTextWidth = skipButtonTitle.boundingRectWithSize(buttonSize, options: drawingOptions, attributes: attributes, context: nil).width
    }
    
    let doneButtonTitle = NSString(string: self.doneButtonTitle)
    doneTextWidth = doneButtonTitle.boundingRectWithSize(buttonSize, options: drawingOptions, attributes: attributes, context: nil).width
    
    var actionButtonWidth = max(doneTextWidth, skipTextWidth) + padding*2
    actionButtonWidth = min(maxButtonWidth, actionButtonWidth)
    self.actionButtonWidthConstraint.constant = floor(actionButtonWidth)
  }
  
  override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
    let offset = CGFloat(self.lastCurrentPageNumber) * CGFloat(self.scrollView.frame.width)
    self.scrollView.setContentOffset(CGPointMake(offset, 0.0), animated: false)
  }
  
  // MARK: - Private Methods
  
  func setupScrollView() {
    if let storyboard = self.storyboard, identifiers = self.storyboardIdentifiers {
      var viewControllers = [UIViewController]()
      for identifier in identifiers {
        if let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier) as? UIViewController {
          viewControllers.append(viewController)
          self.addChildViewController(viewController)
          self.scrollView.addSubview(viewController.view)
        } else {
          assertionFailure("no view controller can be found for identifier (\(identifier))")
        }
      }
      
      for (index, viewController) in enumerate(viewControllers) {
        let view = viewController.view
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        if index == 0 {
          self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view(==scrollView)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": view, "scrollView": self.scrollView]))
        } else if index == viewControllers.count - 1 {
          var previousView = viewControllers[index-1].view
          self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previousView][view(==scrollView)]|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["previousView": previousView, "view": view, "scrollView": self.scrollView]))
        } else {
          var previousView = viewControllers[index-1].view
          self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[previousView][view(==scrollView)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["previousView": previousView, "view": view, "scrollView": self.scrollView]))
        }
        
        self.scrollView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[view(==scrollView)]", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: ["view": view, "scrollView": self.scrollView]))
        
        viewController.didMoveToParentViewController(self)
      }
      
      self.walkthroughViewControllers = viewControllers
      self.pageControl.numberOfPages = viewControllers.count
    }
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return self.applicationStatusBarHidden
  }
  
  // MARK: - Action Methods
  
  @IBAction func tappedDoneSkipButton() {
    self.dismissBlock?()
  }
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentPageNumber = self.currentPageNumber
    self.pageControl.currentPage = currentPageNumber
    
    if let walkthroughViewControllers = self.walkthroughViewControllers {
      let isOnFirstPage = currentPageNumber == 0;
      let isOnLastPage = currentPageNumber == walkthroughViewControllers.count - 1
      self.actionButton.hidden = self.skipButtonTitle?.isEmpty == true && !isOnLastPage
      
      if isOnLastPage {
        self.actionButton.setTitle(self.doneButtonTitle, forState: UIControlState.Normal)
      } else {
        self.actionButton.setTitle(self.skipButtonTitle, forState: UIControlState.Normal)
      }
    }
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    self.lastCurrentPageNumber = self.currentPageNumber
  }
}