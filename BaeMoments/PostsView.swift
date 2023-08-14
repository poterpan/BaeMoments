//
//  PostsView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI

struct PostsView: View {
    var body: some View {
        ScrollView {
            
            Spacer()
                .frame(height: 30)
            
            // Cover photo...
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 316, height: 135)
                      .background(
                        Image("Family_Portrait01")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .clipped()
                      )
                      .cornerRadius(10)
                      .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 2)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding()
                            .foregroundColor(.black.opacity(0.6))

                    }


                }
                .frame(maxWidth: .infinity)

                Image("decorate-6")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55)
                    .rotationEffect(Angle(degrees: 4.33))
                    .offset(x: -20, y: 20)
            }
            
            // Posts...
            
        }
    }
}

#Preview {
    BaseView()
}
