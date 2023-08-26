//
//  CreateNewPost.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct CreateNewPost: View {
    @EnvironmentObject var createPostViewModel: CreatePostViewModel
    @EnvironmentObject var postsListViewModel: PostsListViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    
    @FocusState private var showKeyboard: Bool
    
    var body: some View {
        VStack{
            // 上方按鈕
            HStack{
                Menu {
                    Button("Cancel",role: .destructive){
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                
                Button(action: createPostViewModel.createPost){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal,20)
                        .padding(.vertical,6)
                        .background(.black,in: Capsule())
                }
                .disableWithOpacity(createPostViewModel.postText == "")
            }
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            }
            
            // 貼文區
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    TextField("What's happening?", text: $createPostViewModel.postText, axis: .vertical)
                        .focused($showKeyboard)
                    
                    if let postImageData = createPostViewModel.postImageData,let image = UIImage(data: postImageData) {
                        GeometryReader {
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                /// - Delete Button
                                .overlay(alignment: .topTrailing) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)){
                                            createPostViewModel.postImageData = nil
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .fontWeight(.bold)
                                            .tint(.red)
                                    }
                                    .padding(10)
                                }
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                }
                .padding(15)
            }
            
            Divider()
            
            HStack{
                Button {
                    showImagePicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
                .hAlign(.leading)
                
                Button("Done"){
                    showKeyboard = false
                }
                .opacity(showKeyboard ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: showKeyboard)
            }
            .foregroundColor(.black)
            .padding(.horizontal,15)
            .padding(.vertical,10)
        }
        .vAlign(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        // Convert Image to upload
        .onChange(of: photoItem) { newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self),let image = UIImage(data: rawImageData),let compressedImageData = image.jpegData(compressionQuality: 0.5){
                        /// UI Must be done on Main Thread
                        await MainActor.run(body: {
                            createPostViewModel.postImageData = compressedImageData
                            photoItem = nil
                        })
                    }
                }
            }
        }
        
        // Observe newly created post
        .onChange(of: createPostViewModel.newlyCreatedPost) { newPost in
            // Check if there is a new post
            if let newPost = newPost {
                // Add the new post to the posts list
                self.postsListViewModel.addNewPost(newPost)
            }
            dismiss()
        }
        .alert(createPostViewModel.errorMessage, isPresented: $createPostViewModel.showError, actions: {})
        /// - Loading View
        .overlay {
            LoadingView(show: $createPostViewModel.isLoading)
        }
    }
}

//#Preview {
////    CreateNewPost()
//}
