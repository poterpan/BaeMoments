//
//  BaseView.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/4.
//

import SwiftUI
import SwiftUICam
import SDWebImageSwiftUI
import FloatingButton
import PopupView


struct BaseView: View {
    @EnvironmentObject var baseData: BaseViewModel
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    
    @State var isKid = true
//    @State private var createNewPost: Bool = false
    @StateObject var postsListViewModel = PostsListViewModel()
    @StateObject var createPostViewModel = CreatePostViewModel()
    @StateObject var audioPlayer = AudioPlayer()

    @AppStorage("user_profile_url") var profileURL: URL?
    
    @State private var showPopup = false
    
    @State var isOpen = false
    var textButtons: [TextButton] {
        [
            TextButton(buttonText: "编辑个人资讯") {
                self.isOpen.toggle()
                print("Open Profile")
                //                self.showEditProfileSheet.toggle()
                
            },
            TextButton(buttonText: "退出登入") {
                //                self.viewModel.logout()
                self.isOpen.toggle()
                print("logout")
            }
        ]
    }
    
    // Hiding Tab bar...
    init(){
        UITabBar.appearance().isHidden = true
        
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            // Header...
            VStack(spacing: 0) {
                HStack {
                    Image("TextIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .onAppear{
                            print(accountCreation.userRole)
                        }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
                .padding(.bottom, 8)
                .padding(.horizontal, 20)
                .background(
                    Color.white
                        .ignoresSafeArea()
                        .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: 0)
                )
                Divider()
                    .padding(.horizontal,-15)
                
                ShakeView(showModal: $showPopup)
                    .frame(width: 0, height: 0) // Invisible on the screen
            }
            
            // Tabs content...
            TabView(selection: $baseData.currentTab) {
                
                PostsView()
                    .environmentObject(postsListViewModel)
                    .environmentObject(audioPlayer)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                    .background(Color("background"))
                    .tag(Tab.Post)
                
                EventView()
                    .tag(Tab.Timeline)
                
                MonsterView()
                    .tag(Tab.Monster)
            }
            .overlay(
                // Custom Tab Bar...
                HStack(spacing: 0){
                    // tabButton...
                    
                    if accountCreation.userRole == 2 {
                        TabButton(Tab: .Monster)
                    } else {
                        TabButton(Tab: .Post)
                    }
                    
                    // Center Curved Button...
                    Button {
                        createPostViewModel.createNewPost.toggle()
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
                    
                    if accountCreation.userRole == 2 {
                        TabButton(Tab: .Post)
                    } else {
                        TabButton(Tab: .Timeline)
                    }
                }
                    .background(
                        Color.white
                            .clipShape(CustomCorner(corners: [.topLeft,.topRight]))
                        // shadow...
                            .shadow(color: Color.black.opacity(0.06), radius: 5, x: -5, y: -5)
                            .ignoresSafeArea(.container, edges: .bottom)
                    )
                // hiding tab bar when detail opens...
                //            .offset(y: baseData.showDetail ? 200 : 0)
                ,alignment: .bottom
            )
            .fullScreenCover(isPresented: $createPostViewModel.createNewPost) {
                CreateNewPostCam()
                    .environmentObject(postsListViewModel)
                    .environmentObject(createPostViewModel)
                    .environmentObject(audioPlayer)

            }
        }
        .popup(isPresented: $showPopup) {
            RewindView {
                showPopup = false
            }
        } customize: {
            $0
                .closeOnTap(false)
                .backgroundColor(.black.opacity(0.4))
        }
        .overlay(
            FloatingButton(mainButtonView: MainButton(profileURL: profileURL), buttons: textButtons, isOpen: $isOpen)
                .straight()
                .direction(.bottom)
                .alignment(.right)
                .spacing(6)
                .initialOpacity(0)
                .offset(x: 26, y: -2),
            alignment: .topTrailing // align to the top-right corner
        )
        
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
                    .frame(width: 34, height: 34)
                Text(Tab.description())
                    .font(.caption)
                    .bold()
            }
            .foregroundColor(baseData.currentTab == Tab ? Color("tabSelected") : Color.gray.opacity(0.5))
            .frame(maxWidth: .infinity)
        }
        
    }
}

struct MainButton: View {
    
    var profileURL: URL?
    
    var body: some View {
        
        WebImage(url: profileURL)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30, height: 30)
            .clipShape(Circle())
    }
}


struct TextButton: View {
    
    var buttonText: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "565656"))
            //                .frame(width: 130, alignment: .center)
        }
        .padding(10)
        .background(Color(hex: "A6A6A6"))
        .cornerRadius(8)
    }
}

#Preview {
    BaseView()
}
