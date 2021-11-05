//
//  EditView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/04.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    //    @Binding var profile: Profile
    @State private var profile = Profile()
    @State private var changedName = ""
    @State private var changedImage: UIImage?
    //    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    //    @State private var isImagePickerDisplay = false
    //


    var body: some View {
        NavigationView {
            ZStack{
                Image("books-bg")
                    .grayscale(0.5)
                    .blur(radius: 8)
            VStack {
                HStack {
                    //                Image(uiImage: profile.image!)
                    Image(uiImage: profile.image ?? UIImage(systemName: "person")!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 150, height: 150)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))

                    VStack {
                        Button("Camera") {
                            //                        self.sourceType = .camera
                            //                        self.isImagePickerDisplay.toggle()
                        }.padding()
                        //
                        Button("photo") {
                            //                        self.sourceType = .photoLibrary
                            //                        self.isImagePickerDisplay.toggle()
                        }.padding()
                    }
                }
                //            .sheet(isPresented: self.$isImagePickerDisplay) {
                //                ImagePickerView(selectedImage: $changedImage, sourceType: self.sourceType)
                //            }
                Spacer()
                    .frame(height: 100)
                nameTextField()
                Spacer()
                    .frame(height: 100)
                //photopicker
                //namechaneger
            }
            .navigationBarItems(leading: Button("cancle"){
                self.presentationMode.wrappedValue.dismiss()}
                                ,trailing: Button("save") {
                if let image = changedImage {
                    profile.image = image
                }
                profile.name = changedName
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        }
    }

    fileprivate func nameTextField() -> some View {
        return HStack {
            Image(systemName: "person.circle")
                .foregroundColor(.white)

            TextField("Name", text: $changedName)
                .padding()
                .frame(width: 230, height: 40)
                .disableAutocorrection(true)
                .keyboardType(.default)
                .autocapitalization(.none)
                .background(Color.white
                                .opacity(0.5)
                                .cornerRadius(10))
        }
        .padding(.top, 10)
        .padding(.bottom, 10)
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

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
