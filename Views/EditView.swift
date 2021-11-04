//
//  EditView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/04.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var profile: Profile
    @State private var changed = Profile()
//    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
//    @State private var isImagePickerDisplay = false
//
    var body: some View {
        NavigationView {
//            HStack {
//                Image(uiImage: profile.image!)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .clipShape(Circle())
//                    .frame(width: 150, height: 150)
//                VStack {
//                    Button("Camera") {
//                        self.sourceType = .camera
//                        self.isImagePickerDisplay.toggle()
//                    }.padding()
//
//                    Button("photo") {
//                        self.sourceType = .photoLibrary
//                        self.isImagePickerDisplay.toggle()
//                    }.padding()
//                }
//            }
//            .sheet(isPresented: self.$isImagePickerDisplay) {
//                ImagePickerView(selectedImage: $changed.image, sourceType: self.sourceType)
//            }
            TextField(
                "Input your new name",
                text: $changed.name
            )
                .onAppear(perform: {
                    changed.name = profile.name
                })
            
            //photopicker
            //namechaneger
                .navigationBarItems(leading: Button("cancle"){
                    self.presentationMode.wrappedValue.dismiss()}
                                    ,trailing: Button("save") {
//                    if let image = changed.image {
//                        profile.image = image
//                    }
//                    if let name = changed.name {
//                        profile.name = name
//                    }
                    self.presentationMode.wrappedValue.dismiss()
                })
        }
    }
}
//    fileprivate func editProfile() {
//        // photo picker
//        // 1. remove prev profile
//        // 2. upload new profile
//    }
//    fileprivate func editName() {
//        // libdata isequalto <prev usernickname or uid>
//        // chage to newuid>
//    }
//    fileprivate func editEmail() {
//        // libdata isequalto <prev usernickname or uid>
//        // chage to newuid>
//    }

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//
//    }
//}
