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
    
    @State private var myORmark = false
    
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    private let userAuth = Auth.auth().currentUser
    private let users = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()
    
    var body: some View {
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
            .padding(.bottom, 10)
            .foregroundColor(.mainBlue)
            Divider()
                .padding(.bottom, 15)
            
            ////
            // here start select mybook or bookmarkbook//
            ////
            HStack(alignment: .center){
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        self.myORmark = false
                    }
                }) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width:23, height:23)
                        .foregroundColor(myORmark ? .gray : .mainBlue)
                }
                Spacer()
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        self.myORmark = true
                    }
                }) {
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width:15, height:23)
                        .foregroundColor(myORmark ? .mainBlue : .gray)
                }
                Spacer()
            }
            .padding(.bottom, 15)
            HStack (spacing: 0) {
                Rectangle()
                    .fill(myORmark ? Color.gray : Color.mainBlue)
                    .frame(height: myORmark ? 0.3 : 1.5)
                Rectangle()
                    .fill(myORmark ? Color.mainBlue : Color.gray)
                    .frame(height: myORmark ? 1.5 : 0.3)
            }
            .padding(.bottom, 15)
            ////
            // here end select mybook or bookmarkbook  //
            ////
            Spacer()
            if !myORmark {
                LazyVGrid (columns: columns) {
                    ForEach (books.bookList) { book in
                        NavigationLink(destination: ProfileDetailView(libModel: book)) {
                        ProfileImageRow(libModel: book)
                        }
                    }
                    .foregroundColor(.black)
                }
                .padding()
                .onAppear {
                    books.loadBooks()
                    books.takeBookmarkBook()
                    print("load books")
                }
            }
            else {
                LazyVGrid (columns: columns) {
                    ForEach (books.bookmarkList) { book in
                        NavigationLink(destination: ProfileBookmarkDetailView(libModel: book, books: books)) {
                            ProfilebookmarkImageRow(libModel: book, books: books)
                        }
                    }
                    .foregroundColor(.black)
                }
                .padding()
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
        @Published var bookmarkList: [ViewModel] = []
        @Published var bookmarkarray: [String] = []


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
        
        func takeBookmarkBook() {
            db.collection("users").document(userid).collection("bookmarks").getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
                    var ind: Int = 0
                    for book in books {
                        self.bookmarkList.append(ViewModel(
                            id: book.documentID,
                            useruid: book.get("userid") as! String,
                            name: book.get("username") as! String,
                            email: book.get("useremail") as! String,
                            bookname: book.get("bookname") as! String,
                            author: book.get("author") as! String,
                            title: book.get("title") as! String,
                            content: book.get("content") as! String,
                            created: (book.get("created") as! Timestamp).dateValue(),
                            edited: (book.get("edited") as! Timestamp).dateValue(),
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
        
        func makebookmarklist() {
            db.collection("users").document(userid).collection("bookmarks").getDocuments() { docus, err  in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let docus = docus?.documents else {
                        print("books is nil")
                        return
                    }
                    for docu in docus {
                        self.bookmarkarray.append(docu.get("bookid") as! String)
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
