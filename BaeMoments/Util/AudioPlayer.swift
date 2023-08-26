//
//  AudioRecorder.swift
//  VoiceTest
//
//  Created by Poter Pan on 2023/8/16.
//

import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying = false
    
    func startPlayback(audio: URL) {
        print("URL: \(audio)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
