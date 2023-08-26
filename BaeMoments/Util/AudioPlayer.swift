//
//  AudioRecorder.swift
//  VoiceTest
//
//  Created by Poter Pan on 2023/8/16.
//

import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    var audioPlayer: AVAudioPlayer?
    var player: AVPlayer?

    @Published var isPlaying = false
    
    func startPlayback(audio: URL) {
        print("URL: \(audio)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer?.volume = 1
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func startPlaybackRemote(audioUrl: URL) {
        // Create the destination URL for the audio file
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let destinationUrl = URL(fileURLWithPath: documentsPath).appendingPathComponent(audioUrl.lastPathComponent + ".m4a")
        
        // Check if the file already exists locally
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            playAudio(url: destinationUrl)
        } else {
            // Download the remote audio file
            downloadAudioFile(from: audioUrl, to: destinationUrl)
        }
    }
    
    private func downloadAudioFile(from remoteURL: URL, to localURL: URL) {
        let task = URLSession.shared.downloadTask(with: remoteURL) { [weak self] (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                do {
                    // Move the downloaded file from the temporary location to the desired destination
                    try FileManager.default.moveItem(at: tempLocalUrl, to: localURL)
                    self?.playAudio(url: localURL)
                } catch {
                    print("Error saving the audio file:", error)
                }
            }
        }
        task.resume()
    }
    
    private func playAudio(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true

        // Add observer to listen for playback errors
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerPlaybackFailed(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: player?.currentItem)
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
    
    @objc func playerDidFinishPlaying(_ notification: Notification) {
        print("Audio Player: Playback finished.")
        isPlaying = false

    }
    
    @objc func playerPlaybackFailed(_ notification: Notification) {
        print("Audio Player: Playback failed.")
        
        if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? Error {
            print("Audio Player Error: \(error.localizedDescription)")
        }
    }
    
    deinit {
        // Remove observers when the object is deallocated
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
}
