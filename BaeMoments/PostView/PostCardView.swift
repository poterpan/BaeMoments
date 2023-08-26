//
//  PostCardView.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct PostCardView: View {
//    @EnvironmentObject var audioPlayer: AudioPlayer
    @ObservedObject var audioPlayer: AudioPlayer = AudioPlayer()

    var post: Post
    /// - Callbacks
    var onUpdate: (Post)->()
    var onDelete: ()->()
    /// - View Properties
    @AppStorage("user_UID") private var userUID: String = ""
    @State private var docListner: ListenerRegistration?
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            WebImage(url: post.userProfileURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened))
                    .font(.caption2)
                    .foregroundColor(.gray)
                
                // Post text hidden
//                Text(post.text)
//                    .textSelection(.enabled)
//                    .padding(.vertical,8)
                
                // Voices
                VoicePlayer()

                /// Post Image If Any
                if let postImageURL = post.imageURL{
                    GeometryReader{
                        let size = $0.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .contentShape(Rectangle())
                    }
                    .frame(width: 260, height: 180)
                    .onTapGesture {
                        print("photo")
                    }
                }
                
//                PostInteraction()

            }
        }
        .hAlign(.leading)
        .overlay(alignment: .topTrailing, content: {
            /// Displaying Delete Button (if it's Author of that post)
            if post.userUID == userUID{
                Menu {
                    Button("删除贴文",role: .destructive,action: deletePost)
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.black)
                        .padding(8)
                        .contentShape(Rectangle())
                }
                .offset(x: 8)
            }
        })
        .onAppear {
            /// - Adding Only Once
            if docListner == nil{
                guard let postID = post.id else{return}
                docListner = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot{
                        if snapshot.exists{
                            /// - Document Updated
                            /// Fetching Updated Document
                            if let updatedPost = try? snapshot.data(as: Post.self){
                                onUpdate(updatedPost)
                            }
                        }else{
                            /// - Document Deleted
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear {
            // MARK: Applying SnapShot Listner Only When the Post is Available on the Screen
            // Else Removing the Listner (It saves unwanted live updates from the posts which was swiped away from the screen)
            if let docListner{
                docListner.remove()
                self.docListner = nil
            }
        }
    }
    
    // MARK: Like/Dislike Interaction
//    @ViewBuilder
//    func PostInteraction()->some View{
//        HStack(spacing: 6){
//            Button(action: {}){
//                Image(systemName: true ? "hand.thumbsup.fill" : "hand.thumbsup")
//            }
//            
//            Button(action: {}){
//                Image(systemName: true ? "hand.thumbsdown.fill" : "hand.thumbsdown")
//            }
//            .padding(.leading,25)
//            
//        }
//        .foregroundColor(.black)
//        .padding(.vertical,8)
//    }
    
    // MARK: Voice Player
    @ViewBuilder
    func VoicePlayer()->some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 42)
                .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
            HStack {
                Button(action: {
                    print("play pressed")
                    self.audioPlayer.startPlaybackRemote(audioUrl: post.voiceURL)
                }) {
                    Image(systemName: self.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundColor(.black)
                }
                .padding(10)
                .padding(.horizontal, 10)
                
                Spacer()
                
                Image("soundwave")
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
//                        Text(timeString(time: audioRecorder.recordingDuration))
//                            .padding(.horizontal, 20)
                Text("00:00")
                    .font(.caption)
                    .padding(.horizontal, 20)

            }
        }
        .onTapGesture {
            print("inside")
        }
        .frame(width: 260, height: 40)

    }
    
    /// - Liking Post
//    func likePost(){
//        Task{
//            guard let postID = post.id else{return}
//            if post.likedIDs.contains(userUID){
//                /// Removing User ID From the Array
//                try await Firestore.firestore().collection("Posts").document(postID).updateData([
//                    "likedIDs": FieldValue.arrayRemove([userUID])
//                ])
//            }else{
//                /// Adding User ID To Liked Array and removing our ID from Disliked Array (if Added in prior)
//                try await Firestore.firestore().collection("Posts").document(postID).updateData([
//                    "likedIDs": FieldValue.arrayUnion([userUID]),
//                    "dislikedIDs": FieldValue.arrayRemove([userUID])
//                ])
//            }
//        }
//    }
    
    /// - Dislike Post
//    func dislikePost(){
//        Task{
//            guard let postID = post.id else{return}
//            if post.dislikedIDs.contains(userUID){
//                /// Removing User ID From the Array
//                try await Firestore.firestore().collection("Posts").document(postID).updateData([
//                    "dislikedIDs": FieldValue.arrayRemove([userUID])
//                ])
//            }else{
//                /// Adding User ID To Liked Array and removing our ID from Disliked Array (if Added in prior)
//                try await Firestore.firestore().collection("Posts").document(postID).updateData([
//                    "likedIDs": FieldValue.arrayRemove([userUID]),
//                    "dislikedIDs": FieldValue.arrayUnion([userUID])
//                ])
//            }
//        }
//    }
    
    /// - Deleting Post
    func deletePost(){
        Task{
            /// Step 1: Delete Image from Firebase Storage if present
            do{
                if post.imageReferenceID != ""{
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                /// Step 2: Delete Firestore Document
                guard let postID = post.id else{return}
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}
