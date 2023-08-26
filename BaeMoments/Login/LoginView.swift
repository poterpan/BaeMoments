//
//  LoginView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/2.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            Image("LoginBG-1")
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
                .scaleEffect(1.2)
            
            ZStack(alignment: .center) {
                NavigationView() {
                    VStack {
                        LoginSegmentTabs()
                        Spacer()
                        if !accountCreation.gotoRegister {
                            Login()
                        }
                        else {
                            Register()
                        }
                    }
                }
                .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
            }
            .frame(maxWidth: .infinity, maxHeight: 650)
            .background(
//                Color.white
//                    .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
//                    .ignoresSafeArea(.all, edges: .bottom)
                LinearGradient(gradient: Gradient(colors: [Color("gradientStart"), Color.white, Color("gradientEnd")]), startPoint: .top, endPoint: .bottom)
                    .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
                    .ignoresSafeArea(.all, edges: .bottom)
            )
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AccountCreationViewModel())
}

