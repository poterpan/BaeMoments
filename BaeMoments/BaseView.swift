//
//  BaseView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI

struct BaseView: View {
    @StateObject var baseData = BaseViewModel()
//    @StateObject var homeData = LoginViewModel()
    @State var isKid = true
    
    // Hiding Tab bar...
    init(){
        
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Image("TextIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        
                    Spacer()
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(10)
                        .background(Color.black.opacity(0.08))
                        .clipShape(Circle())
                    
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
                .background(
                    Color.white
                        .ignoresSafeArea()
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: 0)
                )
                Divider()
                    .padding(.horizontal,-15)
            }
            
            TabView(selection: $baseData.currentTab) {
                
                //            Home()
                //                .environmentObject(baseData)
                //                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                .background(Color.black.opacity(0.04))
                //                .tag(Tab.Home)
                
                PostsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("background"))
                    .tag(Tab.Post)
                
                Text("Timeline")
                    .tag(Tab.Timeline)
                
                Text("Monster")
                    .tag(Tab.Monster)
            }
            .overlay(
                
                // Custom Tab Bar...
                HStack(spacing: 0){
                    // tabButton...
                    
                    if isKid {
                        TabButton(Tab: .Monster)
                    } else {
                        TabButton(Tab: .Post)
                    }
                    
                    //                    .offset(x: -10)
                    
                    // Center Curved Button...
                    Button {
                        isKid.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(.white)
                            .offset(x: -1)
                            .padding(18)
                            .background(Color("addButton"))
                            .clipShape(Circle())
                        // shadows..
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                    }
                    .offset(y: -30)
                    
                    if isKid {
                        TabButton(Tab: .Post)
                    } else {
                        TabButton(Tab: .Timeline)
                    }
                    
                    //                    .offset(x: 10)
                }
                .background(
                        Color.white
    //                      .clipShape(CustomCurveShape())
                            .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
                        // shadow...
                            .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                            .ignoresSafeArea(.container, edges: .bottom)
                    )
                // hiding tab bar when detail opens...
    //            .offset(y: baseData.showDetail ? 200 : 0)
                ,alignment: .bottom
        )
        }
        
    }
    
    @ViewBuilder
    func TabButton(Tab: Tab)-> some View{
        
        Button {
            withAnimation{
                baseData.currentTab = Tab
            }
        } label: {
            
            VStack {
                Image(Tab.rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                Text(Tab.description())
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(baseData.currentTab == Tab ? Color("tabSelected") : Color.gray.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
        
    }
}


#Preview {
    BaseView()
}
