//
//  EditView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/04.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var profile: Profile // real profile
//    @State private var profile = Profile() // for testing
    @State private var changedName = ""
    @State private var changedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplay = false
    
    let storage = Storage.storage()
    let userid = Auth.auth().currentUser!.uid
    
    var body: some View {
        NavigationView {
            ZStack{
                Image("books-bg")
                    .grayscale(0.5)
                    .blur(radius: 8)
                VStack {
                    photoPicker()
                    Spacer()
                        .frame(height: 100)
                    
                    nameTextField()
                    Spacer()
                        .frame(height: 100)
                }
                .navigationBarItems(leading: cancleButton() ,trailing: saveButton())
            }
        }
    }
    
    fileprivate func saveButton() -> some View {
        return Button("save") {
            if let image = changedImage {
                profile.image = image
                editProfile()
            }
            if changedName != "" {
                profile.name = changedName
                editName()
            }
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    fileprivate func cancleButton() -> some View {
        return Button("cancle"){
            self.presentationMode.wrappedValue.dismiss()}
    }
    
    fileprivate func photoPicker() -> some View {
        return HStack {
            Image(uiImage: changedImage ?? profile.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 150, height: 150)
                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            VStack {
                Button("Camera") {
                    self.sourceType = .camera
                    self.isImagePickerDisplay.toggle()
                }.padding()
                Button("photo") {
                    self.sourceType = .photoLibrary
                    self.isImagePickerDisplay.toggle()
                }.padding()
            }
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: $changedImage, sourceType: self.sourceType)
        }
    }
    
    fileprivate func nameTextField() -> some View {
        return HStack {
            Image(systemName: "person.circle")
                .foregroundColor(.white)
            
            TextField("\(profile.name)", text: $changedName)
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
    
    fileprivate func editProfile() {
        // photo picker
        // 1. remove prev profile
        let desertRef = storage.reference().child("images/user_profile/\(userid)")
        desertRef.delete { err in
          if let err = err {
              print("an error has occurred - \(err.localizedDescription)")
          } else {
              print("image deleted successfully")
          }
        }
        // 2. upload new profile
        upload_Image(image: changedImage!)
    }
    
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    fileprivate func upload_Image(image:UIImage){
        let image : UIImage = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
        if let imageData = image.jpegData(compressionQuality: 1){
            storage.reference().child("images/user_profile/\(userid)").putData(imageData, metadata: nil){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
        }
    }

    fileprivate func editName() {
        // 1.게시글 중에 이전 유저네임이랑 같은글 전부 수정 or 그냥 un
        Firestore.firestore().collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { infos, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let infos = infos?.documents else {
                    print("books is nil")
                    return
                }
                for info in infos {
                    info.reference.setData(["username": changedName], merge: true)
                }
            }
        }
        // 2.db의 users의 uid같은거에서 유저네임 수정.
        Firestore.firestore().collection("users").document("\(userid)").setData([
            "name": changedName
        ], merge: true) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}

//
//
//struct EditView_Previews: PreviewProvider {
//    var profile = Profile()
//    static var previews: some View {
//        EditView(profile: profile)
//    }
//}
