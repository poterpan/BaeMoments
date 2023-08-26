//
//  PostViewModel.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/15.
//

import SwiftUI
import Combine
import Firebase
import FirebaseStorage

class PostViewModel: ObservableObject {
    @Published var post: Post
    var cancellables = Set<AnyCancellable>()
    
    @AppStorage("user_UID") var userUID: String = ""
    
    init(post: Post) {
        self.post = post
    }
    
    
    // MARK: - Delete Post
    func deletePost() {
        Task {
            // Step 1: Delete Image from Firebase Storage if present
            do {
                if post.imageReferenceID != "" {
                    try await Storage.storage().reference().child("Post_Images").child(post.imageReferenceID).delete()
                }
                // Step 2: Delete Firestore Document
                guard let postID = post.id else { return }
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Other Business Logic
    // ... (e.g., comment on post, etc.)
}

