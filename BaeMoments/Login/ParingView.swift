//
//  ParingView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/7.
//

import SwiftUI
import CodeScanner

struct ParingView: View {
    @EnvironmentObject var homeData : LoginViewModel
    @State var showQRCode = true
    var body: some View {
        
        ZStack(alignment: .center) {
            
            Image("LoginBG-2")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .scaleEffect(1.2)
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white.opacity(0.55))
                        .frame(width: 320, height: 320)
                    if showQRCode {
                        Image("qrcode")
                    } else {
                        CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Paul Hudson") { response in
                            switch response {
                            case .success(let result):
                                print("Found code: \(result.string)")
                                showQRCode.toggle()
                            case .failure(let error):
                                print(error.localizedDescription)
                                showQRCode.toggle()
                            }
                        }
                        .frame(width: 320, height: 320)
                        .cornerRadius(20)
                    }
                }
                HStack(spacing: 30) {
                    Button(action: { print("login") }, label: {
                        HStack{
                            Text("跳过")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.black)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .frame(width: 138)
                        .background(Color("disableButton"))
                        .cornerRadius(8)

                    })

                    Button(action: { print("login") }, label: {
                        HStack{
                            Text("复制连结")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(Color.black)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical,12)
                        .frame(width: 138)
                        .background(Color("blueButton"))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.10), radius: 5, x: 5, y: 5)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    })
                }
            }
        }
        .overlay(
            Image(systemName: showQRCode ? "qrcode.viewfinder" : "qrcode")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(30)
                .onTapGesture {
                    withAnimation {
                        showQRCode.toggle()
                    }
                }
            , alignment: .topTrailing)
    }
}

#Preview {
    ParingView()
        .environmentObject(LoginViewModel())
}
