//
//  ReusablePostsView.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//

import SwiftUI
import Firebase

struct ReusablePostsView: View {
    @EnvironmentObject var postsListViewModel: PostsListViewModel
    @EnvironmentObject var audioPlayer: AudioPlayer

//    var basedOnUID: Bool = false
//    var uid: String = ""
//    @Binding var posts: [Post]
    /// - View Properties
//    @State private var isFetching: Bool = true
    
    /// - Pagination
//    @State private var paginationDoc: QueryDocumentSnapshot?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                if postsListViewModel.isFetching{
                    ProgressView()
                        .padding(.top,30)
                }else{
                    if postsListViewModel.posts.isEmpty{
                        /// No Post's Found on Firestore
                        Text("No Post's Found")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,30)
                    }else{
                        /// - Displaying Post's
                        Posts()
                    }
                }
            }
            .padding(15)
        }
        .refreshable {
            /// - Scroll to Refresh
            /// Disbaling Refresh for UID based Post's
//            guard !basedOnUID else{return}
            await postsListViewModel.refreshPosts()
        }
        .task {
            /// - Fetching For One Time
            ///  fetchPosts() 函數只在 posts 陣列為空時被調用，即只在首次顯示視圖時加載數據。
            guard postsListViewModel.posts.isEmpty else{return}
            await postsListViewModel.fetchPosts()
        }
    }
    
    /// - Displaying Fetched Post's
    @ViewBuilder
    func Posts()->some View{
        ForEach(postsListViewModel.posts){post in
            PostCardView(post: post) { updatedPost in
                /// Updating Post in the Array
                if let index = postsListViewModel.posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
//                    posts[index].likedIDs = updatedPost.likedIDs
//                    posts[index].dislikedIDs = updatedPost.dislikedIDs
                }
            } onDelete: {
                /// Removing Post From the Array
                withAnimation(.easeInOut(duration: 0.25)){
                    postsListViewModel.posts.removeAll{post.id == $0.id}
                }
            }
            .environmentObject(audioPlayer)
            .frame(width: 346)
//            .offset(x: -10)
            .padding(.vertical, 10)
//            .onAppear {
//                /// - When Last Post Appears, Fetching New Post (If There)
//                if post.id == posts.last?.id && paginationDoc != nil{
//                    Task{await fetchPosts()}
//                }
//            }
            
            Divider()
                .padding(.horizontal,-15)
        }
    }
    
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
