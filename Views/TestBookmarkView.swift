//
//  TestBookmarkView.swift
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

struct TestBookmarkView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var books = BookLists()
    
    var body: some View {
        NavigationView{
            VStack {
                TestBookmarkViewTop()
                ScrollView(.vertical) {
                    
                    LazyVGrid(columns: columns) {
                        ForEach (books.bookList ) { book in
                            NavigationLink(destination: SearchDetailView(libModel: book)) {
                                TestBookmarkViewImageRow(libModel: book, bookmarklist: books.bookmarkcheck)
                            }
                        }
                    }
                    .padding()
                    .onAppear(perform: {
                        books.loadBooks()
                        books.makebookmarklist()
                        print("load books")
                    })
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct TestBookmarkViewTop: View {
    
    @State var showAdd = false
    
    var body: some View{
        HStack {
            Text("Books")
                .font(.system(size: 44, weight: .bold))
            Spacer()
            Button(action: {
                self.showAdd.toggle()
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 23, height: 23)
                    .foregroundColor(.mainBlue)
            }
        }
        .padding()
        .padding(.bottom, -30)
        .sheet(isPresented: $showAdd) {
            AddBookInfoView()
        }
    }
}

struct TestBookmarkViewButton: View {
    @State var bookmark: Bool
    var libModel: ViewModel
        let db = Firestore.firestore()
    
    let userId = Auth.auth().currentUser?.uid ?? "userId"
    
    var body: some View {
        Button(action: {
            if bookmark {
                bookmark = false
                deletebookmarkdb()
                print("deletebookmarkdb success")
            }
            else {
                bookmark = true
                setbookmarkdb()
                print("setbookmarkdb success")
            }
            
        }) {
            if bookmark {
                Image(systemName: "bookmark.fill")
                    .foregroundColor(.mainBlue)
            }
            else {
                Image(systemName: "bookmark")
                    .foregroundColor(.mainBlue)
            }
        }
    }
    
    func deletebookmarkdb() {
        let doc = self.db.collection("users").document(userId).collection("bookmarks")
        
        doc.whereField("bookid", isEqualTo: libModel.id).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                for document in snapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    doc.document("\(document.documentID)").delete()
                }
            }})
        
    }
    
    func setbookmarkdb() {
        let doc = self.db.collection("users").document(userId).collection("bookmarks").document()
        doc.setData([
            "author": libModel.author,
            "bookname": libModel.bookname,
            "title": libModel.title,
            "content": libModel.content,
            "created": Date(),
            "edited": Date(),
            "exchange": libModel.exchange
        ])
        doc.setData([
            "price": libModel.price ?? 0,
            "sell": libModel.sell,
            "userid": libModel.useruid,
            "useremail": libModel.email,
            "username": libModel.name,
            "bookid" : libModel.id
        ],merge: true)
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(doc.documentID)
                //                printdb2()
                
                //upload image
                //                if let thisimage = image{
                //                    upload_Image(image: thisimage, docID: doc.documentID)
                //                }
                
                
                //                setSuccess = true
            }
        }
        
    }
}

struct TestBookmarkViewImageRow: View {
    var libModel: ViewModel
    var bookmarklist: [String]
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10){
            ZStack(alignment: .topTrailing ){
                if let image = libModel.image {
                    image
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width / 2.3 , height:UIScreen.main.bounds.width / 2.3)
                        .cornerRadius(19)
                        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: 6, x: 0, y: 3)
                }
                TestBookmarkViewButton(bookmark: checkbookmark(), libModel: libModel)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
            }
            HStack (alignment: .top){
            if libModel.bookname.count > 15 {
                Text(libModel.bookname.prefix(15) + "…")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.mainBlue)
                +
                Text(" ")
                +
                Text(libModel.title)
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.black)
                }
            else {
                Text(libModel.bookname)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.mainBlue)
                +
                Text(" ")
                +
                Text(libModel.title)
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.black)
                }
            }
            
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(height: 45)
                .truncationMode(.tail)
            
            .padding(.bottom, 10)
        }
    }
    
    private func checkbookmark() -> Bool {
        
        if self.bookmarklist.contains(self.libModel.id) {
            return true
        }
        else
        {
            return false
        }
    }
    
}

struct TestBookmarkView_Previews: PreviewProvider {
    static var previews: some View {
        TestBookmarkView()
    }
}


extension TestBookmarkView {
    
    class BookLists: ObservableObject {
        let userId = Auth.auth().currentUser?.uid ?? "userId"
        @Published var bookList: [ViewModel] = []
        @Published var bookmarkcheck: [String] = []
        //    private var bookImage = UIImage(systemName: "book")
        //        private let userid = Auth.auth().currentUser!.uid
        private let db = Firestore.firestore()
        
        func loadBooks() {
            db.collection("libData").getDocuments() { books, err in
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
        
        func makebookmarklist() {
            db.collection("users").document(userId).collection("bookmarks").getDocuments() { docus, err  in
                
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let docus = docus?.documents else {
                        print("books is nil")
                        return
                    }
                    for docu in docus {
                        self.bookmarkcheck.append(docu.get("bookid") as! String)
                    }
                }
            }
        }
        
    }
}
