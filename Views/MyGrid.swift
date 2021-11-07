////
////  MyGrid.swift
////  PrivateLibrary
////
////  Created by 김진범 on 2021/11/05.
////
//
//import SwiftUI
//import Firebase
//import FirebaseAuth
//import FirebaseFirestore
//import FirebaseStorage
//
//
//class BookListModel: ObservableObject {
//    @Published var books = [ViewModel]()
////    private var bookImage = UIImage(systemName: "book")
//    let user = Auth.auth().currentUser
//    let db = Firestore.firestore()
//
//    func loadBooks() {
//        db.collection("libData").getDocuments() { books, err in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                guard let books = books?.documents else {
//                    print("books is nil")
//                    return
//                }
//                for book in books {
//                    self.books.append(ViewModel(
//                        id: book.documentID,
//                        useruid: book.get("userid") as! String,
//                        name: book.get("username") as! String,
//                        email: book.get("useremail") as! String,
//                        bookname: book.get("bookname") as! String,
//                        author: book.get("author") as! String,
//                        title: book.get("title") as! String,
//                        content: book.get("content") as! String,
////                        created: <#T##Date?#>,
////                        edited: <#T##Date?#>,
//                        price: book.get("price") as? Int,
//                        exchange: (book.get("exchange") as! Bool),
//                        sell: (book.get("sell") as! Bool),
//                        image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString())))
//                }
//            }
//        }
//    }
//}
//
//struct MyGrid: View {
//    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
//    @ObservedObject var book = BookListModel()
////    var books = [
////        ViewModel(id: "ss", useruid: "user", name: "name", email: "", bookname: "", author: "", title: "title", content: "", exchange: true, sell: true, image: Image("rainbowlake")),
////        ViewModel(id: "ww",useruid: "user", name: "name", email: "", bookname: "", author: "", title: "title", content: "", exchange: true, sell: true, image: Image("rainbowlake"))
////    ]
//
//
//    var body: some View {
//        LazyVGrid (columns: columns) {
//            ForEach (book.books) { book in
//                ImageRow(libModel: book)
//                    .frame(width: 200, height: 200)
//                    .padding([.top], 5)
//            }
//            .foregroundColor(.black)
//        }
//        .onAppear(perform: {
//            book.loadBooks()
//        })
//        .padding([.leading, .trailing], 10)
//    }
//}
//
//struct MyGrid_Previews: PreviewProvider {
//    static var previews: some View {
//        MyGrid()
//    }
//}
