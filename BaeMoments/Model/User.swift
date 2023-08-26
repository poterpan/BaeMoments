//
//  User.swift
//  SocialMedia
//
//  Created by Balaji on 07/12/22.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable,Codable {
    @DocumentID var id: String?
    var username: String
    var userUID: String
    var userProfileURL: URL
    var userRole: Int
    
    enum CodingKeys: CodingKey {
        case id
        case username
        case userUID
        case userProfileURL
        case userRole
    }
}
