//
//  StackCarouselView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/10.
//
//
//import SwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseAuth
//import FirebaseStorage
//
//struct StackCarouselView: View {
//    @ObservedObject var books = BookLists()
//
//    var body: some View {
//        VStack {
//            Text("asdf")
//                .onAppear(perform: {
//                    books.loadBooks()
//                    print("load books")
//            })
////            StackCarousel(bookModels: books.bookList)
//        }
//    }
//
//}
//
//extension StackCarouselView {
//    class BookLists: ObservableObject {
//        @Published var bookList: [ViewModel] = []
//        //    private var bookImage = UIImage(systemName: "book")
//        private let userid = Auth.auth().currentUser!.uid
//        private let db = Firestore.firestore()
//
//        func loadBooks() {
//            db.collection("libData").getDocuments() { books, err in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    guard let books = books?.documents else {
//                        print("books is nil")
//                        return
//                    }
//                    var ind: Int = 0
//                    for book in books {
//                        self.bookList.append(ViewModel(
//                            id: book.documentID,
//                            useruid: book.get("userid") as! String,
//                            name: book.get("username") as! String,
//                            email: book.get("useremail") as! String,
//                            bookname: book.get("bookname") as! String,
//                            author: book.get("author") as! String,
//                            title: book.get("title") as! String,
//                            content: book.get("content") as! String,
//                            //                        created: <#T##Date?#>,
//                            //                        edited: <#T##Date?#>,
//                            price: book.get("price") as? Int,
//                            exchange: (book.get("exchange") as! Bool),
//                            sell: (book.get("sell") as! Bool),
//                            image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString()),
//                            index: ind))
//                        ind += 1
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//struct StackCarouselView_Previews: PreviewProvider {
//    static var previews: some View {
//        StackCarouselView()
//    }
//}
