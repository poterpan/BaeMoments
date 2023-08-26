//
//  SelectAvatar.swift
//  BaeMoments
//
//  Created by Poter Pan on 2023/8/7.
//

import SwiftUI
import PhotosUI


struct SelectAvatar: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    
//    @State var userProfilePicData: Data?
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    


    var body: some View {
        VStack {
            Text("上传头像")
                .font(.system(size: 24))
                .bold()
                .kerning(7.2)
            
            Spacer()

            VStack {
                ZStack{
                    if let userProfilePicData = accountCreation.userProfilePicData ,let image = UIImage(data: userProfilePicData){
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }else{
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color(UIColor(red: 0.67, green: 0.8, blue: 0.91, alpha: 0.9)))
                    }
                }
                .frame(width: 175, height: 175)
                .clipShape(Circle())
                .contentShape(Circle())
                
                Text("轻触头像编辑")
                    .padding(.top, 10)
                    .foregroundStyle(Color.secondary)
            }

            .onTapGesture {
                showImagePicker.toggle()
            }
//            .padding(.top,25)
            
            
            Spacer()
            
            HStack(spacing: 30) {
                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                    HStack{
                        Text("上一步")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.black)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .frame(width: 138)
                    .background(Color("disableButton"))
                    .cornerRadius(8)

                })
                NavigationLink(destination: SelectRole().environmentObject(accountCreation)) {
                    HStack{
                        Text("下一步")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(Color.black)
                    }
                    .foregroundColor(.white)
                    .padding(.vertical,12)
                    .frame(width: 138)
                    .background(Color("blueButton"))
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.10), radius: 5, x: 5, y: 5)
                }
                
            }
        }
        .padding(.vertical, 50)
        .navigationBarBackButtonHidden(true)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            // MARK: Extracting UIImage From PhotoItem
            if let newValue{
                Task{
                    do{
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else{return}
                        // MARK: UI Must Be Updated on Main Thread
                        await MainActor.run(body: {
                            accountCreation.userProfilePicData = imageData
                        })
                        
                    }catch{}
                }
            }
        }

    }
}

#Preview {
    LoginView()
        .environmentObject(AccountCreationViewModel())
//    SelectAvatar()
}
