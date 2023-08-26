//
//  TestView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/2.
//

import SwiftUI

struct TestView: View {
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        
        VStack{
            
            Image("dating")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.main.bounds.height / 3.5)
                .padding(.vertical)
            
            ZStack{
                
                // Login View...
                
                if 1 == 0{
                    Login()
                }
                else {
                    Register()
                        .transition(.move(edge: .trailing))
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.clipShape(CustomCorner(corners: [.topLeft,.topRight])).ignoresSafeArea(.all, edges: .bottom))
        }
        .background(Color("testred")
        .ignoresSafeArea(.all, edges: .all))
        // alert...
        
    }
}

#Preview {
    TestView()
}
