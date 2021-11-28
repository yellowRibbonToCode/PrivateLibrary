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
    @State private var changedName = ""
    @State private var changedImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var isImagePickerDisplay = false
    @State private var registerError = ""
    @State private var showingActionSheet = false
    @State private var removeProfile = false
    @State private var showDialog = false
    @Environment(\.loginStatus) var loging

    
    let storage = Storage.storage()
    let userid = Auth.auth().currentUser!.uid
    
    fileprivate func finishEdit() -> some View {
        return Button {
            if changedImage != nil {
                if removeProfile == true {
                    removeImage()
                } else {
                    editProfile()
                }
                profile.image = changedImage!
            }
            if changedName != "" {
                profile.name = changedName
                self.editName { isDone in
                    if isDone {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            if changedName == "" {
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("저장")
                .foregroundColor(.white)
                .font(Font.custom("S-CoreDream-5Medium", size: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                        .frame(width: 134, height: 36)
                )
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.mainBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        CircleImageView(image: changedImage ?? profile.image, width: 160 , height: 160)
                            .foregroundColor(.white)
                        Circle()
                            .foregroundColor(.white)
                            .opacity(0.76)
                            .frame(width: 160, height: 160)
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 170, height: 170)
                        Image(systemName: "camera")
                            .frame(width:31, height: 23)
                            .foregroundColor(.mainBlue)
                    }
                    .onTapGesture {
                        self.showingActionSheet = true
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainBlue, lineWidth: 1)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 240, height: 35)
                        
                        TextField("\(profile.name)", text: $changedName)
                            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
                            .background(.white)
                            .padding()
                            .frame(width: 240, height: 35)
                            .disableAutocorrection(true)
                            .keyboardType(.default)
                            .autocapitalization(.none)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 27)
                    finishEdit()
                   

                    Text(registerError)
                        .padding(.top, 20)
                        .foregroundColor(.red)
                }
                .toolbar {
                    ToolbarItem (placement: .navigationBarLeading) {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image("arrow-left-w")
                                .resizable()
                                .frame(width: 18, height: 12)
                        }
                    }
                    ToolbarItem (placement: .navigationBarTrailing) {
                        Button  {
                            showDialog = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                        .confirmationDialog("", isPresented: $showDialog) {
                            Button("로그아웃", role: .destructive) {
                                do {
                                    try Auth.auth().signOut()
                                    print("success log out")
                                    UserDefaults.standard.removeObject(forKey: "id")
                                    UserDefaults.standard.removeObject(forKey: "password")
                                    UserDefaults.standard.removeObject(forKey: "islogin")
                                    self.presentationMode.wrappedValue.dismiss()
                                    self.loging.wrappedValue.toggle()
                                }
                                catch let signOutError as NSError {
                                    print("Error signing out: %@", signOutError)
                                }
                            }
//                            Button("회원탈퇴", role: .destructive) {}
                            Button("취소", role:.cancel) {}
                        }
                        
                        
//                        logoutButton()
                    }
                }
            }
        }
        .confirmationDialog("", isPresented: $showingActionSheet) {
            Button("현재 사진 삭제") {
                self.removeProfile = true
                self.changedImage = UIImage(imageLiteralResourceName: "user-g")
            }
            Button("사진 찍기") {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }
            Button("라이브러리에서 선택") {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }
            Button("취소", role: .cancel) {}
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: $changedImage, sourceType: self.sourceType)
        }
    }
    
    fileprivate func photoPicker() -> some View {
        return VStack {
            Button("Camera") {
                self.sourceType = .camera
                self.isImagePickerDisplay.toggle()
            }.padding()
            Button("photo") {
                self.sourceType = .photoLibrary
                self.isImagePickerDisplay.toggle()
            }.padding()
        }
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: $changedImage, sourceType: self.sourceType)
        }
    }
    
    fileprivate func nameTextField() -> some View {
        return TextField("\(profile.name)", text: $changedName)
            .padding()
            .frame(width: 230, height: 40)
            .disableAutocorrection(true)
            .keyboardType(.default)
            .autocapitalization(.none)
            .background(Color.white
                            .opacity(0.5)
                            .cornerRadius(10))
    }
    
    fileprivate func editProfile() {
        // photo picker
        // 1. remove prev profile
//        removeImage()
//        profile.image = changedImage!
        // 2. upload new profile
        uploadImage(image: changedImage!)
    }
    fileprivate func removeImage() {
        let desertRef = storage.reference().child("images/user_profile/\(userid)")
        desertRef.delete { err in
            if let err = err {
                print("an error has occurred - \(err.localizedDescription)")
            } else {
                UserDefaults.standard.removeObject(forKey: userid)
                print("image deleted successfully")
            }
        }
    }
    
    fileprivate func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    fileprivate func uploadImage(image:UIImage){
        let image : UIImage = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
        if let imageData = image.jpegData(compressionQuality: 1){
            storage.reference().child("images/user_profile/\(userid)").putData(imageData, metadata: nil){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    UserDefaults.standard.set(imageData, forKey: userid)
                    print("image uploaded successfully")
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
        }
    }
    
    func duplicateName(completionHandler: @escaping (Bool) -> Void) {
        var isunique = false
        db.collection("users").getDocuments() {
            querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                isunique = true
                for document in querySnapshot!.documents {
                    let name = document.get("name") as? String ?? ""
                    if name == changedName {
                        registerError = "중복된 아이디입니다."
                        isunique = false
                    }
                }
            }
            completionHandler(isunique)
        }
    }
    
    fileprivate func editName(completionHandler: @escaping (Bool) -> Void) {
        duplicateName { isNotdup in
            if isNotdup {
                // 1.게시글 중에 이전 유저네임이랑 같은글 전부 수정 or 그냥 un
                db.collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { infos, err in
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
                db.collection("users").document("\(userid)").setData([
                    "name": changedName
                ], merge: true) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        UserDefaults.standard.set(changedName, forKey: "name")
                        print("Document successfully written!")
                    }
                }
            }
            completionHandler(isNotdup)
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
