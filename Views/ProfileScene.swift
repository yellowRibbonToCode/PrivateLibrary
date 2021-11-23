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
    @ObservedObject var books : HomeView.BookLists
    @State private var showingEdit = false
    @State var profile = Profile()    
    @State var Juso = "주소 변경"
    @State private var showingJuso = false
    
    @State private var myORmark = false
//    @State var bookMarkList = [ViewModel]()
    
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    private let userAuth = Auth.auth().currentUser
    private let users = db.collection("users")
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
                    Image("edit-p")
                        .renderingMode(.template)
                        .foregroundColor(myORmark ? .gray : .mainBlue)
                }
                Spacer()
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        self.myORmark = true
                    }
                }) {
                    Image("bookmark-g")
                        .renderingMode(.template)
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
                    ForEach (books.bookList.sorted { $0.created!.compare($1.created!) == .orderedDescending} ) { book in
                        NavigationLink(destination: DetailView(libModel: book, showBookmark: false)) {
                        ImageRow(libModel: book, showBookmark: false)
                        }
                    }
                    .foregroundColor(.black)
                }
                .padding()
                .onAppear {
                    books.loadBooks()
                    print("load books")
                }
            }
            else { // bookmark view
                LazyVGrid (columns: columns) {
                    ForEach (books.bookmarkList.sorted { $0.created!.compare($1.created!) == .orderedDescending} ) { book in
                        NavigationLink(destination: DetailView(libModel: book)) {
                            ImageRow(libModel: book)
                        }
                        .foregroundColor(.black)
                    }
                }
                .padding()
                .onAppear {
                    books.bookmarkList = []
                    books.takeBookmarkBook()
                }
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

extension HomeView {
    class BookLists: ObservableObject {
        @Published var bookList: [ViewModel] = []
        @Published var bookmarkList: [ViewModel] = []

        private let userid = Auth.auth().currentUser!.uid
        
        func loadBooks() {
            self.bookList = []
            db.collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
                    for book in books {
                        func getImage(bookuid : String) {
                            if let imageData = UserDefaults.standard.data(forKey: bookuid) {
                                let bookImage = Image(uiImage: UIImage(data: imageData)!)
                                self.bookList.append(ViewModel(
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
                                    image: bookImage))
                            } else {
                                
                            Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                                (imageData, err) in
                                if let _ = err as NSError? {
                                    let randInt = Int.random(in: 0...13)
                                    let bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                                    self.bookList.append(ViewModel(
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
                                        image: bookImage))
                                }
                                else {
                                    let randInt = Int.random(in: 0...13)
                                    var bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                                    if let imageData = imageData {
                                        bookImage = Image(uiImage: UIImage(data: imageData)!)
                                    }
                                    self.bookList.append(ViewModel(
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
                                        image: bookImage))
                                }
                            }
                        }
                        }
                        getImage(bookuid: book.documentID)
                    }
                }
            }
        }
        
        func takeBookmarkBook() {
            self.bookmarkList = []
            db.collection("libData").getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
                    let bookmarks = UserDefaults.standard.array(forKey: "bookmark") as? [String] ?? [String]()
                    for book in books {
                        if !bookmarks.contains(book.documentID){
                            continue
                        }
                        func getImage(bookuid : String) {
                            if let imageData = UserDefaults.standard.data(forKey: bookuid) {
                                let bookImage = Image(uiImage: UIImage(data: imageData)!)
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
                                    image: bookImage))
                            } else {
                                
                            Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                                (imageData, err) in
                                if let _ = err as NSError? {
                                    let randInt = Int.random(in: 0...13)
                                    let bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
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
                                        image: bookImage))
                                }
                                else {
                                    let randInt = Int.random(in: 0...13)
                                    var bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                                    if let imageData = imageData {
                                        bookImage = Image(uiImage: UIImage(data: imageData)!)
                                    }
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
                                        image: bookImage))
                                }
                            }
                        }
                        }
                        getImage(bookuid: book.documentID)
                    }
                }
            }
        }
    }
}

extension ProfileScene {
    fileprivate func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: userAuth!.uid) {
            profile.image = UIImage(data: data)!
            return
        }
        let profileImageRef = storageRef.child("images/user_profile/\(userAuth!.uid)")
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            if let data = data {
                profile.image = UIImage(data: data)!
                UserDefaults.standard.set(data, forKey: userAuth!.uid)
            }
        }
    }
    fileprivate func loadName() {
        if let name = UserDefaults.standard.string(forKey: "name") {
            profile.name = name
            return
        }
        let userInfo = users.document("\(userAuth!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.name = (document.get("name") as! String)
                UserDefaults.standard.set(profile.name, forKey: "name")
                print("loaded name")
            }
        }
    }
    fileprivate func loadEmail() {
        if let mail = UserDefaults.standard.string(forKey: "id") {
            profile.email = mail
            return
        }
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
//
//struct ProfileScene_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ProfileScene()
//        }
//    }
//}
