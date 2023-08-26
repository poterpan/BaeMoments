//
//  CreateNewPost.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//

import SwiftUI
import SwiftUICam

struct SwiftUICamPreview: UIViewRepresentable{
    @EnvironmentObject var camera: SwiftUICamModel
    var view: UIView
    
    func makeUIView(context: Context) ->  UIView {
        return camera.makeUIView(view)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        camera.updateUIView()
    }
}
