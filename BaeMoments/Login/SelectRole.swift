//
//  SelectRole.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/14.
//

import SwiftUI

struct SelectRole: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accountCreation : AccountCreationViewModel

//    @State var userRole = 0

    var body: some View {
        VStack {
            Text("身分")
                .font(.system(size: 24))
                .bold()
                .kerning(7.2)
            
            Spacer()
            
            ZStack {
                Group {
                    if accountCreation.role == 1 {
                        Image("selBG").resizable()
                    } else {
                        Image("unselBG").resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 190)
                .offset(x: -3)
                
                Text("家长")
                    .font(.system(size: 40))
                    .bold()
                    .kerning(12)
            }
            .onTapGesture {
                accountCreation.role = 1
            }
            
            ZStack {
                Group {
                    if accountCreation.role == 2 {
                        Image("selBG").resizable()
                    } else {
                        Image("unselBG").resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 190)
                .offset(x: -3)

                Text("小孩")
                    .font(.system(size: 40))
                    .bold()
                    .kerning(12)
            }
            .onTapGesture {
                accountCreation.role = 2
            }
            
            
            Spacer()
            
            HStack(spacing: 30) {
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    HStack{
                        Text("上一步")
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
                
                Button(action: { accountCreation.registerUser() }, label: {
                    HStack{
                        Text("完成註冊")
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
                })
            }
        }
        .padding(.vertical, 50)
        .navigationBarBackButtonHidden(true)
        .alert(accountCreation.errorMessage, isPresented: $accountCreation.showError, actions: {})
    }
        
}

#Preview {
    SelectRole()
}
