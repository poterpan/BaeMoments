//
//  AudioRecorder.swift
//  VoiceTest
//
//  Created by Poter Pan on 2023/8/16.
//

import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    var audioRecorder: AVAudioRecorder!
    @Published var isRecording = false
    var filePath: URL
    @Published var recordingDuration: TimeInterval = 0
    var timer: Timer?
    
    override init() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        self.filePath = documentsDirectory.appendingPathComponent("audio.m4a")
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            audioRecorder = try AVAudioRecorder(url: self.filePath, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            print("Starting recording...")
            isRecording = true
        } catch {
            print("Failed to set up recording session: \(error)")
        }
        // Reset recording duration
        self.recordingDuration = 0
        
        // Start a timer to update the recording duration
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.recordingDuration += 1
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        print("Recording duration: \(audioRecorder?.currentTime ?? 0) seconds")
        isRecording = false
        // Invalidate the timer
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func getVoiceData() -> Data? {
        do {
            let voiceData = try Data(contentsOf: self.filePath)
            return voiceData
        } catch {
            print("Failed to load voice data: \(error)")
            return nil
        }
    }
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording was not successful.")
        }
    }
}
