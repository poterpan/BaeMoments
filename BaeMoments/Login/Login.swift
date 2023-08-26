//
//  Login.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import SwiftUI

struct Login: View {
    
    @EnvironmentObject var accountCreation : AccountCreationViewModel
//    @State var test = ""
    
    var body: some View {
        
        VStack(spacing: 40) {
            Spacer()
                .frame(maxHeight: 70)
            
            // Account Field
            ZStack {
                VStack(spacing: 8) {
                    Text("帐号")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    TextField("", text: $accountCreation.emailID)
                        .padding(.vertical,10)
                        .padding(.horizontal)
                        .background(Color("textField"))
                        .cornerRadius(8)
                        .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color("blueButton"), lineWidth: 2)
                            )
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                }
                
                Image("decorate-1")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .offset(x: 140, y: -40)
            }
            
            // Password Field
            VStack(spacing: 8) {
                Text("密码")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                TextField("", text: $accountCreation.password)
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color("textField"))
                    .cornerRadius(8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("blueButton"), lineWidth: 2)
                        )
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            }
            
            ZStack {
                Button(action: { accountCreation.loginUser() }, label: {
                    HStack{
                        Text("登入")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.black)
                            .padding(.horizontal, 30)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(Color("blueButton"))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.10), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                })
                .padding(.top, 40)
                
                Image("decorate-2")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 55)
                    .offset(x: -120, y: 100)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 50)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AccountCreationViewModel())

    }
}
