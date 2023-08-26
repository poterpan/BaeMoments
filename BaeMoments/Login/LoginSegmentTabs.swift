//
//  LoginSegmentTabs.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/7.
//

import SwiftUI

struct LoginSegmentTabs: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    var body: some View {
        HStack {
            Text("登入")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(accountCreation.gotoRegister ? Color.gray.opacity(0.3) : Color.white.opacity(0))
                .clipShape(CustomCorner(corners: [.topLeft]))
                .onTapGesture {
                    accountCreation.gotoRegister = false
                }
            
            Text("註冊")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, maxHeight: 60)
                .background(accountCreation.gotoRegister ? Color.white.opacity(0) : Color.gray.opacity(0.3))
                .clipShape(CustomCorner(corners: [.topRight]))
                .onTapGesture {
                    accountCreation.gotoRegister = true
                }
        }
    }
}

//
//#Preview {
//    LoginSegmentTabs()
//}
