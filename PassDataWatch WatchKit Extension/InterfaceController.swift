//
//  InterfaceController.swift
//  PassDataWatch WatchKit Extension
//
//  Created by Mitya Kim on 10/2/22.
//

import WatchKit
import Foundation
import WatchConnectivity // 1 step

class InterfaceController: WKInterfaceController {
    
    @IBOutlet weak var passToIPhoneLabel: WKInterfaceLabel!
    @IBOutlet weak var receiveFromIPhoneLabel: WKInterfaceLabel!
    
    // 3 step create session
    let session = WCSession.default
    
    // 4 step create var for passing to phone
    let status = true
    var message: [String: Any] {
        return ["status": status]
    }
    
    // pass data to iPhone
    func interactiveMessage() {
        session.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    // pass data to iPhone
    func updateStatusLabel() {
        passToIPhoneLabel.setText("Pass to Watch: \(status)")
        passToIPhoneLabel.setTextColor(UIColor.orange)
    }
    
    // received data from iPhone
    func updateLabelWith(message: [String: Any]) {
        if let receiveFromIPhone = message["status"] as? Bool {
            receiveFromIPhoneLabel.setText("Data from iPhone: \(receiveFromIPhone)")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // 3 step
        session.delegate = self
        session.activate()
       
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    // pass data to iPhone action
    @IBAction func passDataButtonPressed() {
        interactiveMessage()
        updateStatusLabel()
    }
}

extension InterfaceController: WCSessionDelegate { // 2 step
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .notActivated:
            print("watch session not activated")
        case .inactive:
            print("watch session inactive state")
        case .activated:
            print("watch session activated")
        @unknown default:
            fatalError()
        }
    }
    
    // 5 step received message from iPhone
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.updateLabelWith(message: message)
        }
    }
}
