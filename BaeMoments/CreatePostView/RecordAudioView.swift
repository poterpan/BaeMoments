//
//  ContentView.swift
//  VoiceTest
//
//  Created by Poter Pan on 2023/8/16.
//

import SwiftUI

struct RecordAudioView: View {
    @ObservedObject var audioRecorder: AudioRecorder = AudioRecorder()
    @EnvironmentObject var audioPlayer: AudioPlayer
    @EnvironmentObject var createPostViewModel: CreatePostViewModel
    @EnvironmentObject var postsListViewModel: PostsListViewModel

    @Environment(\.dismiss) private var dismiss


    @State private var isSending: Bool = false
    
    let picImg: UIImage?
    
    var body: some View {
        
        ZStack {
            VStack {
                if let img = picImg {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 340, height: 480)
                        .clipped()
                        .border(Color.orange, width: 7)
                        .padding()
                } else {
                    // Fallback to a default image
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 340, height: 480)
                        .clipped()
                        .border(Color.orange, width: 7)
                        .padding()
                }

                
                // Record control ...
                if !isSending {
                    HStack {
                        if audioRecorder.isRecording {
                            Text("松开以停止录音: \(timeString(time: audioRecorder.recordingDuration))")
                        }
                    }
                    .frame(width: 340, height: 40)
                    .padding()

                    Image(systemName: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .foregroundColor(.red)
                        .gesture(
                            LongPressGesture(minimumDuration: 0.1)
                                .onEnded { _ in
                                    self.audioRecorder.startRecording()
                                }
                                .sequenced(before: DragGesture(minimumDistance: 0).onEnded { _ in
                                    self.audioRecorder.stopRecording()
                                    self.isSending = true
                                })
                        )
                } else {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .frame(height: 42)
                                .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                            HStack {
                                Button(action: {
                                    self.audioPlayer.startPlayback(audio: self.audioRecorder.filePath)
                                }) {
                                    Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                }
                                .padding(10)
                                .padding(.horizontal, 10)
                                
                                Spacer()
                                
                                Image("soundwave")
                                    .resizable()
                                    .scaledToFit()
                                
                                Spacer()
                                
                                Text(timeString(time: audioRecorder.recordingDuration))
                                    .padding(.horizontal, 20)

                            }
                        }
                        .frame(width: 300)
                        
                        Button { self.isSending = false } label: {
                            Image(systemName: "trash.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(5)
                                .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                        }
                    }
                    .frame(width: 340, height: 40)
                    .padding()
                    
                    Button {
                        compressImage(image: picImg)
                        createPostViewModel.postVoiceData = audioRecorder.getVoiceData()
                        createPostViewModel.createPost()
                    } label: {
                        Image(systemName: "paperplane.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .foregroundColor(Color(UIColor(red: 0.98, green: 0.79, blue: 0.36, alpha: 1)))
                    }
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: NavBackButton(dismiss: self.dismiss)) // Attach custom button
            
            // Observe newly created post
            .onChange(of: createPostViewModel.newlyCreatedPost) { newPost in
                // Check if there is a new post
                if let newPost = newPost {
                    // Add the new post to the posts list
//                    dismiss()
                    self.postsListViewModel.addNewPost(newPost)
                }
                createPostViewModel.createNewPost = false
            }
            .alert(createPostViewModel.errorMessage, isPresented: $createPostViewModel.showError, actions: {})
            
            if createPostViewModel.isLoading {
                LoadingView(show: $createPostViewModel.isLoading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                }
        }
    }
    
    func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func compressImage(image: UIImage?) {
        if let compressedImageData = image!.jpegData(compressionQuality: 0.5){
            /// UI Must be done on Main Thread
            createPostViewModel.postImageData = compressedImageData

        }
    }
    
}

struct NavBackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("< 取消")
                .foregroundStyle(Color.gray)
        }
    }
}


//
//struct RecordAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordAudioView()
//    }
//}

//#Preview {
////    RecordAudioView()
//}
