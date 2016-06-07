//
//  CustomPopoverViewController.swift
//  SimpleNumpad
//
//  Created by Olaf Øvrum on 07.06.2016.
//  Copyright © 2016 Viking Software Solutions. All rights reserved.
//

import UIKit

public class CustomPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    private var viewControllerContext: UIViewController!
    private var contentViewController: UIViewController?
    public var onPopoverDismissed: (() -> ())?
    
    /***
     Returns true/false depending on if the popover is visible or not.
     - Returns: Bool
     */
    public var isVisible: Bool {
        return self.isViewLoaded() && self.view.window != nil
    }
    
    /***
     Initiates a custom popover with the viewcontroller that will present the popover.
     
     - Parameter presentingViewController: The UIViewController that will present the popover.
     - parameter contentViewController: Optionally provide an UIViewController that will provide the popover content.
     */
    public convenience init(presentingViewController: UIViewController, contentViewController: UIViewController? = nil) {
        self.init()
        
        self.viewControllerContext = presentingViewController
        self.contentViewController = contentViewController
        
        if let content = contentViewController {
            self.addChildViewController(content)
            self.preferredContentSize = content.preferredContentSize
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .Popover
    }
    
    /// Use this to reset the popover controller settings to default.
    func prepareForReuse(){
        guard let controller = self.popoverPresentationController else {
            return
        }
        
        controller.permittedArrowDirections = .Any
        controller.passthroughViews = nil
        controller.sourceRect = CGRectZero
        controller.sourceView = nil
        removeContentViewController()
    }
    
    private func removeContentViewController(){
        if let content = self.contentViewController {
            content.dismissViewControllerAnimated(true, completion: {
                content.removeFromParentViewController()
                self.contentViewController = nil
            })
        }
    }
    
    /***
     Present the popover based on the given parameters.
     - Note: If a contentViewController was used in the init(). The popoverContentView should be nil or unwanted behaviour may occur.
     
     - Parameter popoverContentView: An UIView to be used as the popover content. Pass nil if using a contentViewController.
     - Parameter source: An UIView where the popover should be presented within. Optional.
     - Parameter sourceRect: A CGRect where the popover should be presented from.
     - Parameter permittedArrowDirections: Defines the permitted arrow directions. Defaults to .Any.
     - Parameter passThroughViews: An UIView array which contains UIView's that should be interactable during popover presentation. Optional.
     */
    public func presentPopover(popoverContentView: UIView? = nil, sourceView: UIView? = nil, sourceRect: CGRect, permittedArrowDirections: UIPopoverArrowDirection = .Any, passThroughViews: [UIView]? = nil){
        
        if let content = popoverContentView {
            self.view.addSubview(content)
            self.preferredContentSize = content.frame.size
        } else if let content = self.contentViewController {
            self.view.addSubview(content.view)
            self.preferredContentSize = content.preferredContentSize
        } else {
            
            print("Unable to get content for popover. If no contentViewController is defined, there should be a popoverContentView defined in the presentPopover() call. Aborting.")
            
            return
        }
        
        self.viewControllerContext.presentViewController(self, animated: true, completion: nil)
        
        let controller = self.popoverPresentationController!
        
        controller.delegate = self
        controller.permittedArrowDirections = permittedArrowDirections
        controller.passthroughViews = passThroughViews
        controller.sourceRect = sourceRect
        controller.sourceView = sourceView
    }
    
    /***
     Manually dismiss the popover by calling this.
     
     - Parameter animated: Determine whether the dismissal should be animated or not not. Defaults to true.
     */
    public func dismissPopover(animated: Bool = true){
        self.dismissViewControllerAnimated(animated, completion: {
            self.onPopoverDismissed?()
            self.removeContentViewController()
        })
    }
    
    public func popoverPresentationController(popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverToRect rect: UnsafeMutablePointer<CGRect>, inView view: AutoreleasingUnsafeMutablePointer<UIView?>) {
        
    }
    
    public func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.onPopoverDismissed?()
        self.removeContentViewController()
    }
    
    public func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    public func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.superview?.layer.cornerRadius = 0
    }
    
}
