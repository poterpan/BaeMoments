//
//  BaeMomentsApp.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/7/31.
//

import SwiftUI
import Firebase


@main
struct BaeMomentsApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
