//
//ProfileScene.swift
//PrivateLibrary
//
//Created by 김진범 on 2021/11/02.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Profile {
    var image: UIImage?
    var name: String = "Anonymous"
    var email: String = "notyet@load.com"
}

struct ProfileScene: View {
//    @Environment(\.editMode) var editMode
    @State private var showingEdit = false
    
    @State var profile = Profile()
    private let userId = Auth.auth().currentUser!.uid
    private let users = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    
    var body: some View {
        ScrollView {
            HStack {
                CircleImageView(image: profile.image ?? UIImage(systemName: "person")!, width: 100, height: 100)
                    .onAppear {
                        loadProfile()
                    }
                Spacer()
                    .frame(width: 40)
                VStack {
                    Text(profile.name)
                        .font(.title)
                        .foregroundColor(.black)
                        .onAppear{
                            loadName()
                        }
                    Text(profile.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onAppear {
                            loadEmail()
                        }
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Button("Edit") {
                            showingEdit.toggle()
                        }
                        .fullScreenCover(isPresented: $showingEdit, content: {
                            EditView(profile: $profile)
                        })
                        Spacer()
                            .frame(width: 20)
                        Button("signout") {
                            //signout
//                            Auth.auth().signOut()
                            //goto loginview
                            //how????
                        }
                    }
                }
                // gridview
//                MyImageGridView()
            }
        }
        .padding()
    }
    
    fileprivate func loadProfile() {
        let profileImageRef = storageRef.child("images/\(userId)")
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            if let data = data {
                profile.image = UIImage(data: data)
            }
        }
    }
    fileprivate func loadName() {
        let userInfo = users.document("\(userId)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.name = (document.get("name") as! String)
            }
        }
    }
    fileprivate func loadEmail() {
        let userInfo = users.document("\(userId)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.email = (document.get("email") as! String)
            }
        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScene()
        }
    }
}


