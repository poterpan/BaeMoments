//
//  PostsView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI
import Combine
import PopupView

struct EventView: View {
    @State private var createEvent = false

    var body: some View {
        VStack {
            Button {
                createEvent.toggle()
            } label: {
                Image("NewEventButton")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 345)
                    .padding(.vertical)
            }

            ScrollView {
                Image("Events")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 345)

            }
        }
        .popup(isPresented: $createEvent) {
            NewEventView {
                createEvent = false
            }
        } customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}

#Preview {
    EventView()
}

