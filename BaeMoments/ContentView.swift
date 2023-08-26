//
//  ContentView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/7/31.
//

import SwiftUI
import SwiftUICam


struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    @StateObject var accountCreation = AccountCreationViewModel()
    @StateObject var baseData = BaseViewModel()
    
    var body: some View {
        if logStatus {
            BaseView()
                .environmentObject(baseData)
                .environmentObject(accountCreation)
        }else {
            LoginView()
                .environmentObject(accountCreation)
        }
    }
}

#Preview {
    ContentView()
}
