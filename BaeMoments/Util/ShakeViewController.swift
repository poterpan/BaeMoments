//
//  CustomCorner.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import UIKit
import CoreMotion
import SwiftUI

class ShakeViewController: UIViewController {
    
    var motionManager: CMMotionManager!
    var lastAcceleration: CMAcceleration!
    var shakeStartTime: Date?
    
    // ... Other properties ...
    
    var showModal: Binding<Bool>?
    
    init(showModal: Binding<Bool>? = nil) {
        self.showModal = showModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        
        startMonitoringForShakeGesture()
    }
    
//    func startMonitoringForShakeGesture() {
//        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
//            guard let acceleration = data?.acceleration else { return }
//            
//            if self.lastAcceleration != nil {
//                let threshold: Double = 1.5
//                let deltaX = fabs(acceleration.x - self.lastAcceleration.x)
//                let deltaY = fabs(acceleration.y - self.lastAcceleration.y)
//                let deltaZ = fabs(acceleration.z - self.lastAcceleration.z)
//                
//                if (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold) {
//                    
//                    if self.shakeStartTime == nil {
//                        self.shakeStartTime = Date()
//                    } else {
//                        let now = Date()
//                        let elapsed = now.timeIntervalSince(self.shakeStartTime!)
//                        if elapsed >= 0.5 && elapsed <= 2.0 {
//                            self.deviceWasShaken()
//                            self.shakeStartTime = nil // Reset the start time
//                        }
//                    }
//                } else {
//                    self.shakeStartTime = nil // Reset the start time if the shake motion has stopped
//                }
//            }
//            
//            self.lastAcceleration = acceleration
//        }
//    }
    func startMonitoringForShakeGesture() {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
                guard let acceleration = data?.acceleration else { return }
                
                if self.lastAcceleration != nil {
                    let threshold: Double = 1.5
                    let deltaX = fabs(acceleration.x - self.lastAcceleration.x)
                    let deltaY = fabs(acceleration.y - self.lastAcceleration.y)
                    let deltaZ = fabs(acceleration.z - self.lastAcceleration.z)
                    
                    if (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold) {
                        self.deviceWasShaken()
                    }
                }
                
                self.lastAcceleration = acceleration
            }
        }
    func deviceWasShaken() {
        // User shook the device, trigger the desired functionality here
        print("Device was shaken!")
        
        // Trigger to show the modal view
        showModal?.wrappedValue = true
        
        // For example, trigger the function to create a short video from posts
        // createVideoFrom(images: [...], withAudio: "path/to/audio")
    }
}
