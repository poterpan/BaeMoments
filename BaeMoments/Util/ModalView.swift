//
//  CustomCorner.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import SwiftUI

struct ModalView: View {
    
    var body: some View {
        VStack {
            Text("Modal View")
                .font(.largeTitle)
            Text("This is the modal view that appears after shaking the device.")
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
