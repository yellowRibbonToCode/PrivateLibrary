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
    var image: UIImage = UIImage(imageLiteralResourceName: "user-g")
    var name: String = "Anonymous"
    var email: String = "notyet@load.com"
    var emdNm: String = "주소 등록 "
    var sggNm: String = " "
}

struct ProfileScene: View { // View
    @ObservedObject var books = BookLists()
    @State private var showingEdit = false
    @State var profile = Profile()    
    @State var Juso = "주소 변경"
    @State private var showingJuso = false
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    private let userAuth = Auth.auth().currentUser
    private let users = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack {
                    profileImage()
                    Circle()
                        .stroke(Color.mainBlue, lineWidth: 1)
                        .frame(width: 170, height: 170)
                }
                profileName()
                profileEmail()
                HStack(spacing: 0) {
                    Image("location-p")
                        .resizable()
                        .frame(width: 10, height: 15)
                    Button("\(profile.sggNm) \(profile.emdNm)") {
                        showingJuso.toggle()
                    }
                    .font(Font.custom("S-CoreDream-5Medium", size: 16))
                    .onAppear(perform: {
                        loademdNM()
                    })
                    .sheet(isPresented: $showingJuso, content: {
                        LocationRegistration(profile: $profile)
                    })
                }
                .foregroundColor(.mainBlue)
                Divider()
                    .padding(.bottom, 15)
                HStack(spacing: 0){
                    Spacer()
                    Image("edit-p")
                        .resizable()
                        .frame(width:23, height:23)
                        .foregroundColor(.mainBlue)
                    Spacer()
                    Spacer()
                    Image("bookmark-g")
                        .resizable()
                        .frame(width:15, height:23)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 15)
                HStack (spacing: 0) {
                    Rectangle()
                        .fill(Color.mainBlue)
                        .frame(height:1.5)
//                        .padding(.leading)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:0.3)
//                        .padding(.trailing)
                }
                .padding(.bottom, 15)
                
                Spacer()
                
                LazyVGrid (columns: columns) {
                    ForEach (books.bookList) { book in
                        ImageRow(libModel: book)
                            .frame(width: 200, height: 200)
                            .padding([.top], 5)
                    }
                    .foregroundColor(.black)
                }
                .onAppear {
                    books.loadBooks()
                    print("load books")
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("My")
                        .font(.system(size: 34, weight: .bold))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button (action: {showingEdit.toggle()} ) {
                        Image("edit-p")
                            .resizable()
                            .frame(width: 17, height: 17)
                            .foregroundColor(.mainBlue)
                    }.fullScreenCover(isPresented: $showingEdit, onDismiss: {reloadBooks()}) {
                        EditView(profile: $profile)
                    }
                }
            }
        }
    }
    
    fileprivate func profileImage() -> some View {
        return CircleImageView(image: profile.image, width: 160 , height: 160)
            .onAppear {
                loadProfile()
            }
    }
    fileprivate func profileName() -> some View {
        return Text(profile.name)
            .foregroundColor(.mainBlue)
            .fontWeight(.bold)
            .font(Font.system(size: 21))
            .onAppear{
                loadName()
            }
    }
    fileprivate func profileEmail() -> some View {
        return Text(profile.email)
            .fontWeight(.light)
            .font(Font.system(size: 14))
            .tint(Color(red: 148/255, green: 148/255, blue: 152/255))
            .onAppear {
                loadEmail()
            }
    }
    fileprivate func editButton() -> some View {
        return Button("edit") {
            showingEdit.toggle()
        }
        .fullScreenCover(isPresented: $showingEdit, content: {
            EditView(profile: $profile)
                .onDisappear {
                    reloadBooks()
                }
        })
    }
    
    fileprivate func reloadBooks() {
        if (books.bookList.isEmpty || books.bookList[0].name == profile.name) {
            return
        }
        for i in books.bookList.indices {
            books.bookList[i].name = profile.name
        }
        print("reloaded")
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
                        print("somethig appended book")
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
                print("loaded name")
            }
        }
    }
    fileprivate func loadEmail() {
        let userInfo = users.document("\(userAuth!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.email = (document.get("email") as! String)
                print("loaded email")
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
