//
//  PostViewModel.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/15.
//

import SwiftUI
import Firebase
import Combine

class CreatePostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isFetching: Bool = true
    
    private var paginationDoc: QueryDocumentSnapshot?
    private var basedOnUID: Bool = false
    private var uid: String = ""
    
//    init() {
//            Task {
//                await self.refreshPosts()
//            }
//        }
    
    func setup(uid: String, basedOnUID: Bool) {
        self.uid = uid
        self.basedOnUID = basedOnUID
    }
    
    func fetchPosts() async {
        print("Start Fetch")
        do {
            var query: Query!
            if let paginationDoc = paginationDoc {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            if basedOnUID {
                query = query.whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = docs.documents.compactMap { doc -> Post? in
                try? doc.data(as: Post.self)
            }
            print("Mapped")
            await MainActor.run {
                self.posts.append(contentsOf: fetchedPosts)
                self.paginationDoc = docs.documents.last
                self.isFetching = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func refreshPosts() async {
        print("refreshing")
        self.isFetching = true
        self.posts = []
        self.paginationDoc = nil
        await fetchPosts()
        print(posts)
    }
}


