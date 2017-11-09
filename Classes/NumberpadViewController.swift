//
//  NumberpadViewController.swift
//  SimpleNumpad
//
//  Created by Olaf Øvrum on 07.06.2016.
//  Copyright © 2016 Viking Software Solutions. All rights reserved.
//

import UIKit

open class NumberPadViewController : UIViewController {
    
    @IBOutlet var numberPadView: UIInputView!
    
    @IBOutlet var backspaceButton: UIButton!
    
    static var numpadPopover: CustomPopoverViewController?
    
    var onValueChanged: ((String) -> ())?
    
    var value: String = "" {
        
        didSet {
            
            self.onValueChanged?(value)
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        value = value + "\(sender.tag)"
    }
    
    @IBAction func backspace(_ sender: AnyObject) {
        
        if value.isEmpty {
            
            return
        }
        
        value = String(value[..<value.endIndex])
    }
    
    @IBAction func done(_ sender: AnyObject) {
        
        NumberPadViewController.numpadPopover?.dismissPopover()
    }
    
    open class func display(_ onViewController: UIViewController, fromView: UIView, value: Int, onValueChanged: @escaping (String) -> (), passthroughViews: [UIView]?) {
        
        if let popover = numpadPopover {
            
            popover.onPopoverDismissed = {
                
                numpadPopover = nil
                
                display(onViewController, fromView: fromView, value: value, onValueChanged: onValueChanged, passthroughViews: passthroughViews)
            }
            
            popover.dismissPopover(false)
            
            return
        }
        
        let storyboard = UIStoryboard(name: "SimpleNumpad", bundle: Bundle(for: NumberPadViewController.self))
        
        let numpadViewController = storyboard.instantiateViewController(withIdentifier: "NumberPad") as! NumberPadViewController
        
        numpadViewController.value = value == 0 ? "" : "\(value)"
        
        numpadViewController.onValueChanged = onValueChanged
        
        numpadPopover = CustomPopoverViewController(presentingViewController: onViewController, contentViewController: numpadViewController)
        
        numpadPopover?.presentPopover(sourceView: fromView.superview!, sourceRect: fromView.frame, permittedArrowDirections: .down, passThroughViews: passthroughViews)
        
        numpadPopover?.onPopoverDismissed = {
            
            NumberPadViewController.numpadPopover = nil
        }
    }
}
