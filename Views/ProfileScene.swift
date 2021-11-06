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

class BookListModel: ObservableObject {
    @Published var books = [ViewModel]()
    //    private var bookImage = UIImage(systemName: "book")
    let userid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    func loadBooks() {
        db.collection("libData").whereField("userid", isEqualTo: userid).getDocuments() { books, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let books = books?.documents else {
                    print("books is nil")
                    return
                }
                for book in books {
                    self.books.append(ViewModel(
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
                        image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString())))
                }
            }
        }
    }
}


struct ProfileScene: View {
    //    @Environment(\.editMode) var editMode
    @State private var showingEdit = false
    
    @State var profile = Profile()
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var book = BookListModel()
    //    private let userId = Auth.auth().currentUser!.uid
    //    private let users = Firestore.firestore().collection("users")
    //    private let storageRef = Storage.storage().reference()
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                CircleImageView(image: profile.image ?? UIImage(systemName: "person")!, width: 130 , height: 130)
                    .onAppear {
                        profile.image = UIImage(named: "rainbowlake")
                        //                        loadProfile()
                    }
                Spacer()
                    .frame(width: 40)
                VStack {
                    Text(profile.name)
                        .font(.title)
                        .foregroundColor(.black)
                        .onAppear{
                            //                            loadName()
                        }
                    Text(profile.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .onAppear {
                            //                            loadEmail()
                        }
                    Spacer()
                        .frame(height: 10)
                    HStack {
                        Button("Edit") {
                            showingEdit.toggle()
                        }
                        .fullScreenCover(isPresented: $showingEdit, content: {
                            EditView()
                        })
                        Spacer()
                            .frame(width: 20)
                        Button("signout") {
                            //signout
                            do {
                                try Auth.auth().signOut()
                            }
                            catch {
                                print("fail to signout")
                            }
                            //
                            //                            //goto loginview
                            //                            //how????
                        }
                        //                    }
                        //                }
                    }
                }
            }
            .padding()
            LazyVGrid (columns: columns) {
                ForEach (book.books) { book in
                    ImageRow(libModel: book)
                        .frame(width: 200, height: 200)
                        .padding([.top], 5)
                }
                .foregroundColor(.black)
            }
            .onAppear(perform: {
                print("onappear")
                book.loadBooks()
            })
            .padding([.leading, .trailing], 10)
        }
        
        //    fileprivate func loadProfile() {
        //        let profileImageRef = storageRef.child("images/user_profile/\(userId)")
        //        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
        //            if let data = data {
        //                profile.image = UIImage(data: data)
        //            }
        //        }
        //    }
        //    fileprivate func loadName() {
        //        let userInfo = users.document("\(userId)")
        //        userInfo.getDocument { (document, err) in
        //            if let document = document {
        //                profile.name = (document.get("name") as! String)
        //            }
        //        }
        //    }
        //    fileprivate func loadEmail() {
        //        let userInfo = users.document("\(userId)")
        //        userInfo.getDocument { (document, err) in
        //            if let document = document {
        //                profile.email = (document.get("email") as! String)
        //            }
        //        }
    }
}

struct ProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileScene()
        }
    }
}
