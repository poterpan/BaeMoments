//
//  CustomCorner.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import SwiftUI

struct ShakeView: UIViewControllerRepresentable {
    @Binding var showModal: Bool
    
    func makeUIViewController(context: Context) -> ShakeViewController {
        return ShakeViewController(showModal: $showModal)
    }
    
    func updateUIViewController(_ uiViewController: ShakeViewController, context: Context) {
        // We don't need to update the UIViewController in this example.
    }
}
