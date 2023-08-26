//
//  CreateNewPost.swift
//  SocialMedia
//
//  Created by Balaji on 25/12/22.
//
import SwiftUI
import Combine
import AVFoundation

final class CameraModel: ObservableObject {
    private let service = CameraService()
    
    @Published var photo: Photo!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}

struct CreateNewPostCam: View {
    @StateObject var model = CameraModel()
    @EnvironmentObject var audioPlayer: AudioPlayer

    
    @Environment(\.dismiss) private var dismiss
    
    @State private var gotoNextView: Bool = false
    @State private var processing: Bool = false


    @State var currentZoomFactor: CGFloat = 1.0
    
    var captureButton: some View {
        Button(action: {
            model.capturePhoto()
            processing = true
        }, label: {
            Circle()
                .strokeBorder(Color(UIColor(red: 0.98, green: 0.81, blue: 0.44, alpha: 1)), lineWidth: 4)
                .background(Circle().foregroundColor(Color.white).frame(width: 57))
                .frame(width: 73)
        })
    }
    
    
    var flipCameraButton: some View {
        Button(action: {
            model.flipCamera()
        }, label: {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .foregroundColor(.white)
        })
    }
    
    var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .padding(7)
                .frame(width: 40)
                .foregroundColor(Color(UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1)))
        })
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { reader in
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        CameraPreview(session: model.session)
                            .gesture(
                                DragGesture().onChanged({ (val) in
                                    //  Only accept vertical drag
                                    
                                    if abs(val.translation.height) > abs(val.translation.width) {
                                        //  Get the percentage of vertical screen space covered by drag
                                        let percentage: CGFloat = -(val.translation.height / reader.size.height)
                                        //  Calculate new zoom factor
                                        let calc = currentZoomFactor + percentage
                                        //  Limit zoom factor to a maximum of 5x and a minimum of 1x
                                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
                                        //  Store the newly calculated zoom factor
                                        currentZoomFactor = zoomFactor
                                        //  Sets the zoom factor to the capture device session
                                        model.zoom(with: zoomFactor)
                                    }
                                })
                            )
                            .onAppear {
                                model.configure()
                            }
                            .alert(isPresented: $model.showAlertError, content: {
                                Alert(title: Text(model.alertError.title), message: Text(model.alertError.message), dismissButton: .default(Text(model.alertError.primaryButtonTitle), action: {
                                    model.alertError.primaryAction?()
                                }))
                            })
                            .overlay(
                                Group {
                                    if model.willCapturePhoto {
                                        Color.black
                                    }
                                }
                            )
                            .animation(.easeInOut)
                            .frame(width: 375, height: 625)

                        
                        HStack {
                            
                            closeButton
                            
                            Spacer()
                            
                            if processing {
                                Image(systemName: "gearshape.arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                                    .frame(width: 73)
                                    .foregroundColor(.black)
                                    .background(Color(UIColor(red: 0.98, green: 0.81, blue: 0.44, alpha: 1)).clipShape(Circle()))
                            } else {
                                captureButton
                            }
                            
                            Spacer()
                            
                            flipCameraButton
                            
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    if let photo = model.photo {
                        NavigationLink(destination: RecordAudioView(picImg: photo.image), isActive: $gotoNextView) {
                            EmptyView()
                        }
                    }
                }
            }

        }
        .onReceive(model.$photo) { newPhoto in
                    if newPhoto != nil {
                        self.gotoNextView = true
                        self.processing = false
                    }
                }
    }
}


//#Preview {
//    CreateNewPostCam()
//        .environmentObject(CreatePostViewModel())
//        .environmentObject(PostsListViewModel())
//}


//struct SwiftUICamPreview: UIViewRepresentable {
//    
//    @ObservedObject var camera: CameraWrapper
//    var view: UIView
//
//    func makeUIView(context: Context) ->  UIView {
//        return camera.makeUIView(view)
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) { }
//}
