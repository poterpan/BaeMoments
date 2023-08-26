//
//  CustomCorner.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import UIKit
import CoreMotion

class ShakeViewController: UIViewController {
    
    var motionManager: CMMotionManager!
    var lastAcceleration: CMAcceleration!
    var shakeStartTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
        
        startMonitoringForShakeGesture()
    }
    
    func startMonitoringForShakeGesture() {
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            guard let acceleration = data?.acceleration else { return }
            
            if self.lastAcceleration != nil {
                let threshold: Double = 1.5
                let deltaX = fabs(acceleration.x - self.lastAcceleration.x)
                let deltaY = fabs(acceleration.y - self.lastAcceleration.y)
                let deltaZ = fabs(acceleration.z - self.lastAcceleration.z)
                
                if (deltaX > threshold && deltaY > threshold) || (deltaX > threshold && deltaZ > threshold) || (deltaY > threshold && deltaZ > threshold) {
                    
                    if self.shakeStartTime == nil {
                        self.shakeStartTime = Date()
                    } else {
                        let now = Date()
                        let elapsed = now.timeIntervalSince(self.shakeStartTime!)
                        if elapsed >= 0.5 && elapsed <= 2.0 {
                            self.deviceWasShaken()
                            self.shakeStartTime = nil // Reset the start time
                        }
                    }
                } else {
                    self.shakeStartTime = nil // Reset the start time if the shake motion has stopped
                }
            }
            
            self.lastAcceleration = acceleration
        }
    }
    
    func deviceWasShaken() {
        // User shook the device, trigger the desired functionality here
        print("Device was shaken!")
        
        // For example, trigger the function to create a short video from posts
        // createVideoFrom(images: [...], withAudio: "path/to/audio")
    }
}
