//
//  ViewController.swift
//  SinchCalling_Swift
//
//  Created by Yogish on 19/01/16.
//  Copyright © 2016 TnE. All rights reserved.
//

enum EButtonsBar: Int {
    
    case Decline
    case Hangup
    
}

class CallViewController: SINUIViewController, SINCallDelegate {
    
    @IBOutlet var remoteUserName: UILabel!
    @IBOutlet var callStateLabel: UILabel!
    @IBOutlet var declineButton: UIButton!
    @IBOutlet var answerButton: UIButton!
    @IBOutlet var endCallBUtton: UIButton!
    
    var durationTimer: NSTimer?
    var call:SINCall?
    var audioController:SINAudioController {
        let appDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        return (appDelegate.client?.audioController())!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if call?.direction == .Incoming {
            setCallStatus("")
            showButtons(.Decline)
            self.audioController.startPlayingSoundFile(self.pathForSound("incoming.wav"), loop: true)
        }
        else {
            setCallStatusText("calling.....")
            showButtons(.Hangup)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        remoteUserName.text = call?.remoteUserId!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Call Actions
    
    @IBAction func accept(sender: AnyObject) {
        
        audioController.stopPlayingSoundFile()
        call?.answer()
        
    }
    
    @IBAction func decline(sender: AnyObject) {
        
        call?.hangup()
        dismiss()
        
    }
    
    @IBAction func hangUp(sender: AnyObject) {
        
        call?.hangup()
        dismiss()
        
    }
    
    // MARK: - SINCallDelegate 
    
    func callDidProgress(call: SINCall!) {
        setCallStatusText("ringing....")
        audioController.startPlayingSoundFile(pathForSound("ringback.wav"), loop: true)
    }
    
    func callDidEstablish(call: SINCall!) {
        startCallDurationTimerWithSelector(Selector("onDurationTimer:"))
        showButtons(.Hangup)
        audioController.stopPlayingSoundFile()
    }
    
    func callDidEnd(call: SINCall!) {
        dismiss()
        audioController.stopPlayingSoundFile()
        stopCallDurationTimer()
    }
    
    // MARK: - Sounds
    
    func pathForSound(soundName: String) -> String {
        let resourcePath = NSBundle.mainBundle().resourcePath! as NSString
        return resourcePath.stringByAppendingPathComponent(soundName)
    }

}

// MARK: - This extension contains UI helper methods for CallViewController

extension CallViewController {
    
    // MARK: - Call Status
    
    func setCallStatusText(text: String) {
        callStateLabel.text = text
    }
    
    func setCallStatus(text: String) {
        self.callStateLabel.text = text
    }
    
    // MARK: - Buttons
    
    func showButtons(buttons: EButtonsBar) {
        if buttons == .Decline {
            answerButton.hidden = false
            declineButton.hidden = false
            endCallBUtton.hidden = true
        }
        else if buttons == .Hangup {
            endCallBUtton.hidden = false
            answerButton.hidden = true
            declineButton.hidden = true
        }
    }
    
    // MARK: - Duration
    
    func setDuration(seconds: Int) {
        setCallStatusText(String(format: "%02d:%02d", arguments: [Int(seconds / 60), Int(seconds % 60)]))
    }
    
    func internal_updateDurartion(timer: NSTimer) {
        
        let selector:Selector = NSSelectorFromString(timer.userInfo as! String)
        
        if self.respondsToSelector(selector) {
            self.performSelector(selector, withObject: timer)
        }
        
    }
    
    func startCallDurationTimerWithSelector(selector: Selector) {
        let selectorString  = NSStringFromSelector(selector)
        durationTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(CallViewController.internal_updateDurartion(_:)), userInfo: selectorString, repeats: true)
    }
    
    func stopCallDurationTimer() {
        durationTimer?.invalidate()
        durationTimer = nil
    }
    
}
