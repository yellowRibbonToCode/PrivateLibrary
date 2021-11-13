//
//ProfileScene.swift
//PrivateLibrary
//
//Created by 김진범 on 2021/11/02.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ProfileScene: View {
    @EnvironmentObject var backend : Backend
    @ObservedObject var books = BookLists()
    @State private var showingEdit = false
    @State var profile = Profile()
    
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
 
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
                books.loadBooks(backend)
                print("load books")
            })
            .padding([.leading, .trailing], 10)
        }
    }
    
    fileprivate func profileImage() -> some View {
        return CircleImageView(image: profile.image, width: 130 , height: 130)
            .onAppear {
//                loadProfile()
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
    
    fileprivate func signoutButton() -> some View {
        return Button("signout") {
            do {
                try Auth.auth().signOut()
                print("success log out")
                backend.user = nil
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
        
        func loadBooks(_ backend: Backend) {
            print("loadBooks")
            backend.libData.whereField("userid", isEqualTo: backend.user!.uid).getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
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
                            image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString())))
                    }
                }
            }
        }
    }
}

extension ProfileScene {
    fileprivate func loadProfile() {
        let profileImageRef = backend.imagesRef.child("user_profile/\(backend.user!.uid)")
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            if let data = data {
                profile.image = UIImage(data: data)!
                print("loaded profileImage")
            }
        }
    }
    fileprivate func loadName() {
        let userInfo = backend.users.document("\(backend.user!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.name = (document.get("name") as! String)
                print("loaded name")
            }
        }
    }
    fileprivate func loadEmail() {
        let userInfo = backend.users.document("\(backend.user!.uid)")
        userInfo.getDocument { (document, err) in
            if let document = document {
                profile.email = (document.get("email") as! String)
                print("loaded email")
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
