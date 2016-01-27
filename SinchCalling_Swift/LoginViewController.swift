//
//  LoginViewController.swift
//  SinchCalling_Swift
//
//  Created by Yogish on 27/01/16.
//  Copyright © 2016 TnE. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var nameTextField: PaddedTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
    }
        
    @IBAction func onLoginButtonPressed(sender: AnyObject) {
        
        if nameTextField.text?.characters.count == 0 {
            return
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLoginNotification", object: nil, userInfo: ["userId" : self.nameTextField.text!])
        self.performSegueWithIdentifier("mainView", sender: nil)
    }
    
}
