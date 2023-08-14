//
//  Register.swift
//  Dating App
//
//  Created by Balaji on 10/12/20.
//

import SwiftUI
import CoreLocation

struct Register: View {
    @State var test = ""
    
    var body: some View {
        
        VStack(spacing: 20) {
            Spacer()
                .frame(maxHeight: 20)
            
            // Account Field
            VStack(spacing: 8){
                Text("昵称")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                TextField("", text: $test)
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
            
            // Account Field
            VStack(spacing: 8){
                Text("帐号")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                TextField("", text: $test)
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
            
            
            // Password Field
            VStack(spacing: 8){
                Text("密码")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                TextField("", text: $test)
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
            
            // Password Field
            VStack(spacing: 8){
                Text("密码确认")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5)
                TextField("", text: $test)
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
                NavigationLink {
                    SelectAvatar()
                        
                } label: {
                    HStack{
                        Text("注册")
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
                }
                .padding(.top, 40)

//                Button(action: { print("login") }, label: {
//                    
//                })
//                .padding(.top, 40)
                
                Image("decorate-3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 45)
                    .offset(x: -140, y: -20)
                
                Image("decorate-4")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 35)
                    .offset(x: -110, y: 40)
                
                Image("decorate-5")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .offset(x: 130, y: 0)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 50)
        .onAppear(perform: {
            //            manager.delegate = accountCreation
        })
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
