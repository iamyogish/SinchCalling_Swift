//
//  MainViewController.swift
//  SinchCalling_Swift
//
//  Created by Yogish on 27/01/16.
//  Copyright © 2016 TnE. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, SINCallClientDelegate {

    @IBOutlet var destination: PaddedTextField!
    @IBOutlet var callButton: UIButton!
    
    var client: SINClient {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.client!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func awakeFromNib() {
        self.client.callClient().delegate = self
    }
    
    @IBAction func call(sender: AnyObject) {
        if destination.text?.characters.count > 0 && self.client.isStarted() {
            let call: SINCall = self.client.callClient().callUserWithId(destination.text)
            performSegueWithIdentifier("callView", sender: call)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let callViewController = segue.destinationViewController as? CallViewController
        callViewController?.call = (sender as! SINCall)
    }
    
    // MARK: - SINCallClientDelegate
    
    func client(client: SINCallClient!, didReceiveIncomingCall call: SINCall!) {
        performSegueWithIdentifier("callView", sender: call)
    }
    
    func client(client: SINCallClient!, localNotificationForIncomingCall call: SINCall!) -> SINLocalNotification! {
        let notification = SINLocalNotification()
        notification.alertAction = "Answer"
        notification.alertBody = String(format: "Incoming call from %@", arguments: [call.remoteUserId])
        return notification
    }
    
}
