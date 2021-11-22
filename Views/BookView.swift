//
//  TestBookView.swift
//  동네북
//
//  Created by SSB on 2021/11/13.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct BookView: View {
    var Views = ["Books", "NeighborBooks"]
    @State var selectedView = 0
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var books = BookLists()
    @State var booklist = [ViewModel]()
    
    @State var selectedNumber: Int = 0
    
    var customLabel: some View {
        HStack {
            Image(systemName: "paperplane")
            Text(String(selectedNumber))
            Spacer()
            Text("⌵")
                .offset(y: -4)
        }
        .foregroundColor(.white)
        .font(.title)
        .padding()
        .frame(height: 32)
        .background(Color.blue)
        .cornerRadius(16)
    }
    
    var body: some View {
        //        NavigationView{
        VStack {
            if !booklist.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        ForEach (booklist.sorted { $0.created!.compare($1.created!) == .orderedDescending }) { book in
                            NavigationLink(destination: DetailView(libModel: book)) {
                                ImageRow(libModel: book)
                            }
                        }
                    }
                    .padding()
                }
            }
            else {
                Image(systemName: "circle.hexagonpath.fill")
            }
            
        }
        
        .onAppear(perform: {
            db = Firestore.firestore()
            booklist = []
            books.loadBooks(){
                Book in
                booklist.append(Book)
            }
            print("load books")
        })

    }
}



struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
    }
}


extension BookView {
    
    class BookLists: ObservableObject {
        let userId = Auth.auth().currentUser!.uid
        @Published var bookList: [ViewModel] = []
        @Published var bookmarkarray: [String] = []
        private let db = Firestore.firestore()
        
        func loadBooks(completionHandler: @escaping (ViewModel) -> Void) {
            self.bookList = []
            db.collection("libData").whereField("userid", isNotEqualTo: userId).getDocuments() { books, err in
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
                                completionHandler(ViewModel(
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
                                        completionHandler(ViewModel(
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
                                        UserDefaults.standard.set(imageData, forKey: bookuid)
                                        completionHandler(ViewModel(
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
