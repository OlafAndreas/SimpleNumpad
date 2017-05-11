//
//  CustomPopoverViewController.swift
//  SimpleNumpad
//
//  Created by Olaf Øvrum on 07.06.2016.
//  Copyright © 2016 Viking Software Solutions. All rights reserved.
//

import UIKit

open class CustomPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    fileprivate var viewControllerContext: UIViewController!
    fileprivate var contentViewController: UIViewController?
    open var onPopoverDismissed: (() -> ())?
    
    /***
     Returns true/false depending on if the popover is visible or not.
     - Returns: Bool
     */
    open var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
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
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .popover
    }
    
    /// Use this to reset the popover controller settings to default.
    func prepareForReuse(){
        guard let controller = self.popoverPresentationController else {
            return
        }
        
        controller.permittedArrowDirections = .any
        controller.passthroughViews = nil
        controller.sourceRect = CGRect.zero
        controller.sourceView = nil
        removeContentViewController()
    }
    
    fileprivate func removeContentViewController(){
        if let content = self.contentViewController {
            content.dismiss(animated: true, completion: {
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
    open func presentPopover(_ popoverContentView: UIView? = nil, sourceView: UIView? = nil, sourceRect: CGRect, permittedArrowDirections: UIPopoverArrowDirection = .any, passThroughViews: [UIView]? = nil){
        
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
        
        self.viewControllerContext.present(self, animated: true, completion: nil)
        
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
    open func dismissPopover(_ animated: Bool = true){
        self.dismiss(animated: animated, completion: {
            self.onPopoverDismissed?()
            self.removeContentViewController()
        })
    }
    
    open func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        
    }
    
    open func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.onPopoverDismissed?()
        self.removeContentViewController()
    }
    
    open func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
    open func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.superview?.layer.cornerRadius = 0
    }
    
}
