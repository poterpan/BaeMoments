//
//  PostViewModel.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/15.
//

import SwiftUI
import Firebase
import FirebaseStorage
import Combine

class CreatePostViewModel: ObservableObject {
    
    /// - Post Properties
//    @State private var postText: String = ""
//    @State private var postImageData: Data?
//    /// - Stored User Data From UserDefaults(AppStorage)
//    @AppStorage("user_profile_url") private var profileURL: URL?
//    @AppStorage("user_name") private var userName: String = ""
//    @AppStorage("user_UID") private var userUID: String = ""
//    /// - View Properties
//    @Environment(\.dismiss) private var dismiss
//    @State private var isLoading: Bool = false
//    @State private var errorMessage: String = ""
//    @State private var showError: Bool = false
//    @State private var showImagePicker: Bool = false
//    @State private var photoItem: PhotosPickerItem?
    
    // Input
    @Published var postText: String = ""
    @Published var postImageData: Data?
    @Published var postVoiceData: Data?
    
    // Output
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    @Published var newlyCreatedPost: Post?  // Newly created post
    @Published var createNewPost: Bool = false


    
    // Dependencies
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    
    // Callback to inform PostsListViewModel about the new post
    var onPostCreated: ((Post) -> Void)?
    
    // MARK: Post Content To Firebase
    func createPost(){
        isLoading = true
//        showKeyboard = false
        Task{
            do{
                guard let profileURL = profileURL else{return}
                /// Step 1: Uploading Image If any
                /// Used to delete the Post(Later shown in the Video)
                let referenceID = "\(userUID)\(Date())"
                let imgStorageRef = Storage.storage().reference().child("Post_Images").child(referenceID)
                let voiceStorageRef = Storage.storage().reference().child("Post_Voices").child(referenceID)
                
                // Step 1: Uploading Image
                if let postImageData = postImageData, let postVoiceData = postVoiceData {
                    let _ = try await imgStorageRef.putDataAsync(postImageData)
                    let imageDownloadURL = try await imgStorageRef.downloadURL()
                    
                    // Step 2: Uploading Voice
                    let _ = try await voiceStorageRef.putDataAsync(postVoiceData)
                    let voiceDownloadURL = try await voiceStorageRef.downloadURL()
                    
                    // Step 3: Create Post Object With Image and Voice URLs and IDs
                    let post = Post(text: postText, imageURL: imageDownloadURL, imageReferenceID: referenceID, voiceURL: voiceDownloadURL, voiceReferenceID: referenceID, userName: userName, userUID: userUID, userProfileURL: profileURL)
                    
                    try await createDocumentAtFirebase(post)
                }

//                if let postImageData{
//                    let _ = try await imgStorageRef.putDataAsync(postImageData)
//                    let downloadURL = try await imgStorageRef.downloadURL()
//                    
//                    /// Step 3: Create Post Object With Image Id And URL
//                    let post = Post(text: postText, imageURL: downloadURL, imageReferenceID: imageReferenceID, userName: userName, userUID: userUID, userProfileURL: profileURL)
//                    try await createDocumentAtFirebase(post)
//                }else{
//                    /// Step 2: Directly Post Text Data to Firebase (Since there is no Images Present)
//                    let post = Post(text: postText, userName: userName, userUID: userUID, userProfileURL: profileURL)
//                    try await createDocumentAtFirebase(post)
//                }
            }catch{
                await setError(error)
            }
        }
    }
    
    func createDocumentAtFirebase(_ post: Post)async throws{
        /// - Writing Document to Firebase Firestore
        let doc = Firestore.firestore().collection("Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil{
                /// Post Successfully Stored at Firebase
                self.isLoading = false
                var updatedPost = post
                updatedPost.id = doc.documentID
                // Publish the new Post instance
                self.newlyCreatedPost = updatedPost
                self.createNewPost = false
//                dismiss()
            }
        })
    }
    
    // MARK: Displaying Errors as Alert
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}
