//
//ProfileScene.swift
//PrivateLibrary
//
//Created by 김진범 on 2021/11/02.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Profile { // Model
    var image: UIImage = UIImage(systemName: "person")!
    var name: String = "Anonymous"
    var email: String = "notyet@load.com"
    var emdNm: String = "주소 등록 "
    var sggNm: String = " "
}

struct ProfileScene: View { // View
    //    @Environment(\.editMode) var editMode
    
    @ObservedObject var books = BookLists()
    @State private var showingEdit = false
    @State var profile = Profile()
    @Environment(\.loginStatus) var loging
    
    @State var Juso = "주소 변경"
    @State private var showingJuso = false
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    private let userAuth = Auth.auth().currentUser
    private let users = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                profileImage()
                Spacer()
                    .frame(width: 40)
                VStack {
                    profileName()
                    profileEmail()
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        editButton()
                        Spacer()
                            .frame(width: 20)
                        signoutButton()
                    }
                    Button("\(profile.sggNm) \(profile.emdNm)") {
                        showingJuso.toggle()
                    }
                    .onAppear(perform: {
                        loademdNM()
                    })
//                    .fullScreenCover(isPresented: $showingJuso, content: {
//                        LocationRegistration()
//                    })
                    .sheet(isPresented: $showingJuso, content: {
                        LocationRegistration(profile: $profile)
                    }) 
                }
            }
            .padding()
            LazyVGrid (columns: columns) {
                ForEach (books.bookList) { book in
                    ImageRow(libModel: book)
                        .frame(width: 200, height: 200)
                        .padding([.top], 5)
                }
                .foregroundColor(.black)
            }
            .onAppear(perform: {
                books.loadBooks()
                print("load books")
            })
            .padding([.leading, .trailing], 10)
        }
    }
    
    fileprivate func profileImage() -> some View {
        return CircleImageView(image: profile.image, width: 130 , height: 130)
            .onAppear {
                profile.image = UIImage(named: "rainbowlake")!
                loadProfile()
            }
    }
    fileprivate func profileName() -> some View {
        return Text(profile.name)
            .font(.title)
            .foregroundColor(.black)
            .onAppear{
                loadName()
            }
    }
    fileprivate func profileEmail() -> some View {
        return Text(profile.email)
            .font(.subheadline)
            .foregroundColor(.gray)
            .onAppear {
                loadEmail()
            }
    }
    fileprivate func editButton() -> some View {
        return Button("Edit") {
            showingEdit.toggle()
        }
        .fullScreenCover(isPresented: $showingEdit, content: {
            EditView(profile: $profile)
        })
    }
    fileprivate func signoutButton() -> some View {
        return Button("signout") {
            do {
                try Auth.auth().signOut()
                print("success log out")
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "password")
                self.loging.wrappedValue.toggle()
            }
            catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
        }
    }
}

extension ProfileScene {
    class BookLists: ObservableObject {
        @Published var bookList: [ViewModel] = []
        //    private var bookImage = UIImage(systemName: "book")
        private let userid = Auth.auth().currentUser!.uid
        private let db = Firestore.firestore()
        
        func loadBooks() {
            db.collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
                    var ind: Int = 0
                    for book in books {
                        self.bookList.append(ViewModel(
                            id: book.documentID,
                            useruid: book.get("userid") as! String,
                            name: book.get("username") as! String,
                            email: book.get("useremail") as! String,
                            bookname: book.get("bookname") as! String,
                            author: book.get("author") as! String,
                            title: book.get("title") as! String,
                            content: book.get("content") as! String,
                            //                        created: <#T##Date?#>,
                            //                        edited: <#T##Date?#>,
                            price: book.get("price") as? Int,
                            exchange: (book.get("exchange") as! Bool),
                            sell: (book.get("sell") as! Bool),
                            image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString()),
                            index: ind))
                        ind += 1
                    }
                }
            }
        }
    }
}

extension ProfileScene {
    fileprivate func loadProfile() {
        let profileImageRef = storageRef.child("images/user_profile/\(userAuth!.uid)")
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            if let data = data {
                profile.image = UIImage(data: data)!
            }
        }
    }
    fileprivate func loadName() {
        let userInfo = users.document("\(userAuth!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.name = (document.get("name") as! String)
            }
        }
    }
    fileprivate func loadEmail() {
        let userInfo = users.document("\(userAuth!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.email = (document.get("email") as! String)
            }
        }
    }
    fileprivate func loademdNM() {
        let userInfo = users.document("\(userAuth!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.emdNm = (document.get("emdNm") as! String? ?? "주소 등록 ")
                profile.sggNm = (document.get("sggNm") as! String? ?? " ")
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
