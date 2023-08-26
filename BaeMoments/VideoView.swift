//
//  LoadingView.swift
//  SocialMedia
//
//  Created by Balaji on 08/12/22.
//

import SwiftUI
import AVKit
import AVFoundation


struct VideoPlayerView: View {
    private let player: AVPlayer
    @State private var playerError: Error? = nil
    
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
        print("player start")
        self.player.play()
    }
    
    var body: some View {
        VideoPlayer(player: player)
            .onAppear() {
                print("player start")
                player.play()
            }
            .onChange(of: player.currentItem?.status, perform: { status in
                if status == .failed {
                    playerError = player.currentItem?.error
                    print("Player error: \(String(describing: playerError))")
                }
            })
    }
}

