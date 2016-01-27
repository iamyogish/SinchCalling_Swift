//
//  SINUIViewController.swift
//  SinchCalling_Swift
//
//  Created by Yogish on 27/01/16.
//  Copyright © 2016 TnE. All rights reserved.
//

import UIKit
import ObjectiveC

class SINUIViewController: UIViewController {

    var isAppearing: Bool = false
    var isDisappearing:Bool = false
    var sin_deferredDismissalKey: Character!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        guard  (view.window != nil) else {
            return
        }
        
        isAppearing = false
        isDisappearing = false
    }
    
    override func viewWillAppear(animated: Bool) {
        isAppearing = true
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        isAppearing = false
        dismissIfNecessary()
    }
    
    override func viewWillDisappear(animated: Bool) {
        isDisappearing = true
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        isAppearing = false
    }
    
    func dismiss() {
        
        if isDisappearing {
            return
        }
        else if isAppearing {
            setShouldDeferredDismiss(true)
            return
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dismissIfNecessary() {
        if shouldDeferrDismiss() {
            setShouldDeferredDismiss(false)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismiss()
            })
        }
    }
    
    func setShouldDeferredDismiss(shouldDefer: Bool) {
        sin_setAssociatedBOOL(shouldDefer, key: &sin_deferredDismissalKey)
    }
    
    func shouldDeferrDismiss() -> Bool {
        return sin_getAssociatedBOOLForKey(&sin_deferredDismissalKey)
    }
    
    func sin_getAssociatedBOOLForKey(key: UnsafePointer<Void>) -> Bool {
        let number = objc_getAssociatedObject(self, key) as? NSNumber;
        guard number != nil else {
            return false
        }
        return number!.boolValue
    }
    
    func sin_setAssociatedBOOL(v: Bool, key: UnsafePointer<Void>) {
        objc_setAssociatedObject(self, key, NSNumber(bool: v), objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    
}
