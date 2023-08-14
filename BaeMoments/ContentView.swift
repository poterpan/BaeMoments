//
//  ContentView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/7/31.
//

import SwiftUI

struct ContentView: View {
    @StateObject var homeData = LoginViewModel()
    
    var body: some View {
        LoginView()
            .environmentObject(homeData)
            
    }
}

#Preview {
    ContentView()
}
