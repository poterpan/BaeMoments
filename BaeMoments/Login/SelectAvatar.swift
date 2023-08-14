//
//  SelectAvatar.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/7.
//

import SwiftUI

struct SelectAvatar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            Text("這是放大頭貼的地方")
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

                Button(action: { print("login") }, label: {
                    HStack{
                        Text("下一步")
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
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SelectAvatar()
}
