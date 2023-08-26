//
//  AccountCreationViewModel.swift
//  SharedLogin (iOS)
//
//  Created by Balaji on 11/01/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// Getting user Location....

class AccountCreationViewModel: NSObject,ObservableObject {

    // User Details...
    @Published var username = ""
    @Published var emailID = ""
    @Published var password = ""
    @Published var reEnter = ""
    @Published var userProfilePicData: Data?
    @Published var role: Int = 0
    
    // refrence For View Changing
    // ie Login To Register to Image Uplaod
    @Published var gotoRegister = false

    // Images....
    @Published var images = Array(repeating: Data(count: 0), count: 4)
    @Published var picker = false
    
    // ErrorView Details...
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    // Loading Screen...
    @Published var isLoading = false
    
    
    // MARK: User Defaults
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("user_role") var userRole: Int = 0
    @AppStorage("log_status") var logStatus = false
    
    func loginUser(){
        isLoading = true
//        closeKeyboard()
        Task{
            do{
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            }catch{
                await setError(error)
            }
        }
    }
    
    // MARK: If User if Found then Fetching User Data From Firestore
    func fetchUser()async throws{
        guard let userID = Auth.auth().currentUser?.uid else{return}
        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        // MARK: UI Updating Must be Run On Main Thread
        await MainActor.run(body: {
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            userRole = user.userRole
            logStatus = true
            print("logStatus: \(logStatus)")
        })
    }
    
    func resetPassword(){
        Task{
            do{
                // With the help of Swift Concurrency Auth can be done with Single Line
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch{
                await setError(error)
            }
        }
    }
    
    func registerUser(){
        isLoading = true
//        closeKeyboard()
        Task{
            do{
                print("Start Register")
                // Step 1: Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                print("created Firebase Account")
                // Step 2: Uploading Profile Photo Into Firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData = userProfilePicData else{return}
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                print("uploaded pic")
                
                // Step 3: Downloading Photo URL
                let downloadURL = try await storageRef.downloadURL()
                
                // Step 4: Creating a User Firestore Object
                let user = User(username: username, userUID: userUID, userProfileURL: downloadURL, userRole: role)
                
                // Step 5: Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil{
                        // MARK: Print Saved Successfully
                        print("Saved Successfully")
                        self.userNameStored = self.username
                        self.userUID = userUID
                        self.profileURL = downloadURL
                        self.userRole = self.role
                        self.logStatus = true
                    }
                })
            }catch{
                print("Error during registration: \(error.localizedDescription)")
                // MARK: Deleting Created Account In Case of Failure
                try await Auth.auth().currentUser?.delete()
                await setError(error)
            }
        }
    }
    
    func printUserInfo() {
        print(username)
        print(emailID)
        print(password)
        print(role)
        if userProfilePicData != nil {
            print("Pic Data Selected")
        }
    }
    
    // MARK: Displaying Errors VIA Alert
    func setError(_ error: Error)async{
        // MARK: UI Must be Updated on Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
            print(errorMessage)
        })
    }
    
}

