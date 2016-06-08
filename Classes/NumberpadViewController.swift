//
//  NumberpadViewController.swift
//  SimpleNumpad
//
//  Created by Olaf Øvrum on 07.06.2016.
//  Copyright © 2016 Viking Software Solutions. All rights reserved.
//

import UIKit

public class NumberPadViewController : UIViewController {
    
    @IBOutlet var numberPadView: UIInputView!
    
    @IBOutlet var backspaceButton: UIButton!
    
    static var numpadPopover: CustomPopoverViewController?
    
    var onValueChanged: ((String) -> ())?
    
    var value: String = "" {
        
        didSet {
            
            print(value)
            self.onValueChanged?(value)
        }
    }
    
    @IBAction func numberPressed(sender: UIButton) {
        
        value = value.stringByAppendingString("\(sender.tag)")
    }
    
    @IBAction func backspace(sender: AnyObject) {
        
        if value.isEmpty {
            
            return
        }
        
        value = value.substringToIndex(value.endIndex.predecessor())
    }
    
    @IBAction func done(sender: AnyObject) {
        
        NumberPadViewController.numpadPopover?.dismissPopover()
    }
    
    public class func display(onViewController: UIViewController, fromView: UIView, value: Int, onValueChanged: (String) -> (), passthroughViews: [UIView]?) {
        
        if let popover = numpadPopover {
            
            popover.onPopoverDismissed = {
                
                numpadPopover = nil
                
                display(onViewController, fromView: fromView, value: value, onValueChanged: onValueChanged, passthroughViews: passthroughViews)
            }
            
            popover.dismissPopover(false)
            
            return
        }
        
        let storyboard = UIStoryboard(name: "SimpleNumpad", bundle: NSBundle(forClass: NumberPadViewController.self))
        
        let numpadViewController = storyboard.instantiateViewControllerWithIdentifier("NumberPad") as! NumberPadViewController
        
        numpadViewController.value = value == 0 ? "" : "\(value)"
        
        numpadViewController.onValueChanged = onValueChanged
        
        numpadPopover = CustomPopoverViewController(presentingViewController: onViewController, contentViewController: numpadViewController)
        
        numpadPopover?.presentPopover(sourceView: fromView.superview!, sourceRect: fromView.frame, permittedArrowDirections: .Down, passThroughViews: passthroughViews)
        
        numpadPopover?.onPopoverDismissed = {
            
            NumberPadViewController.numpadPopover = nil
        }
    }
}