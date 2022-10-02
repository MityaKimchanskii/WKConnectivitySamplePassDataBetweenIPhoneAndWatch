//
//  ViewController.swift
//  PassDataIPhoneAndWatch
//
//  Created by Mitya Kim on 10/2/22.
//

import UIKit
import WatchConnectivity // 1 step

class ViewController: UIViewController {
    
    @IBOutlet weak var statusToWatchLabel: UILabel!
    @IBOutlet weak var receiveStatusFromWatchLabel: UILabel!
    
    // 3 step
    let session = WCSession.default
    
    // 4 step create var for passing to watch
    let status = false
    var message: [String: Any] {
        return ["status": status]
    }
    
    // 5 step create var for passing to watch
    func interactiveMessage() {
        session.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
    
    func updateStatusLabel() {
        statusToWatchLabel.text = "Pass to Watch: \(status)"
        statusToWatchLabel.backgroundColor = .orange
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 3 step
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    // 6 pass data to watch action
    @IBAction func passDataPressed(_ sender: Any) {
        interactiveMessage()
        updateStatusLabel()
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        statusToWatchLabel.text = "Status To Watch"
        statusToWatchLabel.backgroundColor = .systemGreen
        receiveStatusFromWatchLabel.text = "Receive Data From Watch"
    }
    
    
}

extension ViewController: WCSessionDelegate { // 2 step
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        switch activationState {
        case .notActivated:
            print("phone session not activated")
        case .inactive:
            print("phone session inactive state")
        case .activated:
            print("phone session activated")
        @unknown default:
            fatalError()
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session went inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("session went deactivated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            self.receiveStatusFromWatchLabel.text = "message from watch: \(message["status"])"
        }
    }
}

