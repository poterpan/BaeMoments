//
//  LoginViewModel.swift
//  SharedLogin (iOS)
//
//  Created by Balaji on 11/01/21.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    /// View Properties
    @Published var username = ""
    @Published var password = ""
    @Published var reEnter = ""
    @Published var gotoRegister = false
    
    
    /// Clearing Data When Going to Login / Register Page
    func clearData() {
        username = ""
        password = ""
        reEnter = ""
    }
}
