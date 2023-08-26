////
////  CreateNewPost.swift
////  SocialMedia
////
////  Created by Balaji on 25/12/22.
////
//
//import SwiftUI
//import PhotosUI
//import Firebase
//import FirebaseStorage
//import SwiftUICam
//
//
//struct CreateNewPostCamBak: View {
//    @Environment(\.dismiss) private var dismiss
//    let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 625))
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                Color.black
//                    .ignoresSafeArea()
//                
//                VStack {
//                    SwiftUICamPreview(view: self.view)
//                        .frame(width: 375, height: 625)
//                        .onTapGesture(count: 2) {
//                            camera.toggleCamera()
//                        }
//                        .onAppear {
//                            camera.flashEnabled = false
//                        }
//                    
//                    Spacer()
//                    
////                    if camera.image != nil {
////                        Image(uiImage: camera.image!)
////                    }
//                    
//                    HStack(spacing: 66) {
//                        Button {
//                            camera.retakePic()
//                            dismiss()
//                        } label: {
//                            Image(systemName: "xmark")
//                                .resizable()
//                                .scaledToFit()
//                                .padding(7)
//                                .frame(width: 40)
//                                .foregroundColor(Color(UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)))
//                        }
//
//                        if camera.picTaken && camera.image != nil {
//                            NavigationLink {
//                                RecordAudioView(picImg: camera.image)
//                            } label: {
//                                Image(systemName: "arrow.right.circle.fill")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 73)
//                                    .foregroundColor(Color(UIColor(red: 0.98, green: 0.81, blue: 0.44, alpha: 1)))
//                            }
//
//                        } else {
//                            Button {
//                                camera.takePic()
//                            } label: {
//                                Circle()
//                                    .strokeBorder(Color(UIColor(red: 0.98, green: 0.81, blue: 0.44, alpha: 1)), lineWidth: 4)
//                                    .background(Circle().foregroundColor(Color.white).frame(width: 57))
//                                    .frame(width: 73)
//                            }
//                        }
//                        
//                        
//                        if camera.picTaken {
//                            Button {
//                                camera.retakePic()
//                            } label: {
//                                Image(systemName: "arrowshape.turn.up.backward")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 40)
//                                    .foregroundColor(.white)
//                            }
//                        } else {
//                            Button {
//                                camera.toggleCamera()
//                            } label: {
//                                Image(systemName: "arrow.triangle.2.circlepath.circle")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 40)
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        
//                    }
//
//                    .padding()
//
//                }
//            }
//        }
//    }
//}
//
//
//
//
//
//
////#Preview {
////    CreateNewPostCam()
////        .environmentObject(CreatePostViewModel())
////        .environmentObject(PostsListViewModel())
////}
//
//
////struct SwiftUICamPreview: UIViewRepresentable {
////    
////    @ObservedObject var camera: CameraWrapper
////    var view: UIView
////
////    func makeUIView(context: Context) ->  UIView {
////        return camera.makeUIView(view)
////    }
////
////    func updateUIView(_ uiView: UIView, context: Context) { }
////}
