//
//ProfileScene.swift
//PrivateLibrary
//
//Created by 김진범 on 2021/11/02.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class Profile: ObservableObject {
    @Published private var profileImage: UIImage
    @Published private var profileName: String
    @Published private var profileEmail: String
    private var userInfo: DocumentReference
    
    private let userid = Auth.auth().currentUser
    private let profileImageRef = Storage.storage().reference().child("images/user_profile")
    
    init () {
        userInfo = Firestore.firestore().collection("users").document(userid!.uid)
        profileImage = UIImage(systemName: "person")!
        profileName = "Anonymous"
        profileEmail = "notyet@load.com"
    }
    
    var image: UIImage {
        get {
            loadProfile()
            return profileImage
        }
        set {
            profileImage = newValue
            //update DB
        }
    }
    var name: String {
        get {
            loadName()
            return profileName
        }
        set {
            profileName = newValue
            //update DB
            //users & libdata
        }
    }
    var email: String {
        get {
            loadEmail()
            return profileEmail
        }
    }
    fileprivate func loadProfile() {
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            guard err == nil else { return }
            self.profileImage = UIImage(data: data!)!
        }
    }
    fileprivate func loadName() {
        userInfo.getDocument { document, err in
            guard err == nil else { return }
            self.profileName = document?.get("name") as! String
        }
    }
    fileprivate func loadEmail() {
        userInfo.getDocument { document, err in
            guard err == nil else { return }
            self.profileEmail = document?.get("email") as! String
        }
    }
}

struct ProfileScene: View {
    @ObservedObject var profile: Profile = Profile()
    @Environment(\.editMode) var editMode
    @State private var showingEdit = false
    
    var body: some View {
        ScrollView {
            HStack {
                CircleImageView(image: profile.image, width: 100, height: 100)
                Spacer()
                    .frame(width: 40)
                VStack {
                    Text(profile.name)
                        .font(.title)
                        .foregroundColor(.black)
                    Text(profile.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer()
                        .frame(height: 10)
                    Button("Edit") {
                        self.showingEdit.toggle()
                    }
                    .fullScreenCover(isPresented: $showingEdit, content: {
                        EditView(profile: profile)
                    })
                }
                // gridview
            }
        }
        .padding()
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScene()
        }
    }
}


