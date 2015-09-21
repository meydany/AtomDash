//
//  SessionConnectingViewController.swift
//  AtomDashSwift
//
//  Created by Oran Luzon on 9/19/15.
//  Copyright © 2015 MilkyShakeMobile. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import SpriteKit
import CoreBluetooth

class SessionConnectingViewController: UIViewController, MCBrowserViewControllerDelegate {
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        /*
        connectButton = UIButton(type: UIButtonType.RoundedRect)
        connectButton.backgroundColor = UIColor(red: 0.62, green: 0.85, blue: 0.94, alpha: 1)
        connectButton.bounds = CGRect(x: 0, y: 0, width: view.frame.width/2.5, height: view.frame.height/8)
        connectButton.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        connectButton.setTitle("CONNECT", forState: UIControlState.Normal)
        connectButton.titleLabel?.font = UIFont(name: "DIN-Condensed-Bold", size: 50)
        connectButton.addTarget(self, action: Selector("connectToPlayer"), forControlEvents: UIControlEvents.TouchUpInside)
        */

        self.title = "SessionConnectingViewController"
        
        // Configure the view.
        let skView = SKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.multipleTouchEnabled = false
        view.addSubview(skView)
        
        let chooseConnectionType = ChooseMultiplayerConnectionType(size: skView.frame.size)
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mpcHandler.setupPeerWithDisplayName(UIDevice.currentDevice().name)
        appDelegate.mpcHandler.setupSession()
        appDelegate.mpcHandler.advertiseSelf(true)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "peerChangedStateWithNotification:", name: "MPC_DidChangeStateNotification", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRecievedDataWithNotification:", name: "MPC_DidReceiveDataNotification", object: nil)
        
        skView.presentScene(chooseConnectionType)
        chooseConnectionType.addBluetoothConnectButton()
        //self.view.addSubview(connectButton)
    }
    
    func connectToPlayer() {
        if appDelegate.mpcHandler.session != nil{
            appDelegate.mpcHandler.setupBrowser()
            appDelegate.mpcHandler.browser.delegate = self
        
            self.presentViewController(appDelegate.mpcHandler.browser, animated: true, completion: nil)
        }
    }
    
    func peerChangedStateWithNotification(notification: NSNotification){
        let userInfo = NSDictionary(dictionary: notification.userInfo!)
        
        let state = userInfo.objectForKey("state") as! Int
        
        if state != MCSessionState.Connecting.rawValue{
            print("ur connected bror")
        }
        if state == MCSessionState.Connected.rawValue{
            print("Its officaial")
        }
    }
    
    func handleRecievedDataWithNotification(notification: NSNotification){
        let userInfo = notification.userInfo! as Dictionary
        let recievedData: NSData = userInfo["data"] as! NSData
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController) {
        appDelegate.mpcHandler.browser.dismissViewControllerAnimated(true, completion: nil)
    }
}