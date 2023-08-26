//
//  LoadingView.swift
//  SocialMedia
//
//  Created by Balaji on 08/12/22.
//

import SwiftUI
import PopupView

struct RewindView: View {
    var onClose: () -> Void
    
    @State var showOpenedEgg = false
    
    var body: some View {
        ZStack{
            Image("Machine")
                .resizable()
                .scaledToFit()
                .frame(width: 330)
            
            Image("Eggs")
                .resizable()
                .scaledToFit()
                .frame(width: 190)
                .offset(y: 26)
                .onTapGesture {
                    showOpenedEgg.toggle()
                }
            
            VStack {
                Button {
                    print("Get EXP")
                    onClose()
                } label: {
                    Text("获取经验 0/1")
                        .font(
                            Font.custom("Inter", size: 14)
                                .weight(.medium)
                        )
                        .kerning(1.4)
                        .foregroundColor(Color(red: 0.32, green: 0.32, blue: 0.32))
                        .padding(6)
                        .padding(.horizontal, 4)
                        .background(Color(UIColor(red: 0.89, green: 0.81, blue: 0.57, alpha: 1)).cornerRadius(10).background(Color(UIColor(red: 0.86, green: 0.71, blue: 0.27, alpha: 1)).cornerRadius(10).offset(y:2)))
                }
            }
            .offset(y: 106)


        }
        .overlay(alignment: .topTrailing) {
            if !showOpenedEgg{
                Button(action: { onClose() }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .padding(8)
                        .foregroundStyle(.black)
                        .background(Color(hex: "D9D9D9").opacity(0.7).clipShape(Circle()))
                        .frame(width: 30, height: 30)
                })
            }
        }
        .popup(isPresented: $showOpenedEgg) {
            OpenedEggView {
                showOpenedEgg = false
            }
        } customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
    }
}


struct OpenedEggView: View {
    var onClose: () -> Void

    var body: some View {
        VStack {
            if let url = URL(string: "https://streamable.com/l/7w0gxf/mp4.mp4") {
                VideoPlayerView(url: url)
                    .onAppear {
                        print("Video URL: \(url)")
                    }
            } else {
                Text("Not Found")
                    .onAppear {
                        print("Video file not found")
                    }
            }
        }
        .frame(width: 308, height: 548)
        .overlay(alignment: .topTrailing) {
            Button(action: { onClose() }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .padding(8)
                    .foregroundStyle(.black)
                    .background(Color(hex: "D9D9D9").opacity(0.7).clipShape(Circle()))
                    .frame(width: 30, height: 30)
            })
        }
//        Image("OpenedEgg")
//            .resizable()
//            .scaledToFit()
//            .frame(width: 308)
//            .overlay(alignment: .topTrailing) {
//                Button(action: { onClose() }, label: {
//                    Image(systemName: "xmark")
//                        .resizable()
//                        .padding(8)
//                        .foregroundStyle(.black)
//                        .background(Color(hex: "D9D9D9").opacity(0.7).clipShape(Circle()))
//                        .frame(width: 30, height: 30)
//                })
//            }
    }
}

#Preview {
    RewindView(onClose: {})
}
