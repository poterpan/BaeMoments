//
//  Post.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//

import SwiftUI
import FirebaseFirestoreSwift

// MARK: Post Model
struct Post: Identifiable,Codable,Equatable,Hashable {
    @DocumentID var id: String?
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var voiceURL: URL
    var voiceReferenceID: String
    // MARK: Basic User Info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID
        case voiceURL
        case voiceReferenceID
        case publishedDate
        case userName
        case userUID
        case userProfileURL
    }
}
