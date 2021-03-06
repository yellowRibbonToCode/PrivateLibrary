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
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    let useruid = Auth.auth().currentUser!.uid
    @ObservedObject var books = getBookList()
    @State var booklist = [ViewModel]()
    
    var body: some View {
        VStack {
            if !books.bookList.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        ForEach (books.bookList.sorted { $0.created!.compare($1.created!) == .orderedDescending }) { book in
                            if (book.reports!.count < 2 && !book.blocks!.contains(useruid)) {
                                NavigationLink(destination: DetailView(libModel: book)) {
                                    ImageRow(libModel: book)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            else {
                ProgressView()
                    .tint(.mainBlue)
            }
        }
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        BookView()
    }
}

class GetBookImage: ObservableObject {
    @Published var bookImage = Image(systemName: "book")
    func getImage(bookuid : String, completion: @escaping (Image) -> Void){
        if let imageData = UserDefaults.standard.data(forKey: bookuid) {
            completion(Image(uiImage: UIImage(data: imageData)!))
        } else {
            Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                (imageData, err) in
                if let _ = err as NSError? {
                    let randInt = Int.random(in: 0...13)
                    completion(Image(RandBookImage(rawValue: randInt)!.toString()))
                }
                else {
                    let randInt = Int.random(in: 0...13)
                    self.bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                    if let imageData = imageData {
                        UserDefaults.standard.set(imageData, forKey: bookuid)
                        completion(Image(uiImage: UIImage(data: imageData)!))
                    }
                }
            }
        }
    }
}

class getBookList: ObservableObject {
    @Published var bookList: [ViewModel] = []
    @ObservedObject var getBookImage = GetBookImage()
    
    init () {
        loadBookList()
    }
    
    func loadBookList() {
        db.collection("libData").addSnapshotListener {
            (snapshot, err) in
            guard let documents = snapshot?.documentChanges else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            documents.forEach({ QueryDocumentSnapshot in
                if (QueryDocumentSnapshot.type == .added){
                    let data = QueryDocumentSnapshot.document.data()
                    let id = QueryDocumentSnapshot.document.documentID
                    let useruid = data["userid"] as? String ?? ""
                    let name = data["username"] as? String ?? ""
                    let email = data["useremail"] as? String ?? ""
                    let bookname = data["bookname"] as? String ?? ""
                    let author = data["author"] as? String ?? ""
                    let title = data["title"] as? String ?? ""
                    let content = data["content"] as? String ?? ""
                    let created = (data["created"] as? Timestamp)?.dateValue()
                    let edited = (data["edited"] as? Timestamp)?.dateValue()
                    let price = data["price"] as? Int
                    let exchange = data["exchange"] as? Bool ?? false
                    let sell = data["sell"] as? Bool ?? false
                    let blocks = data["blocks"] as? [String] ?? []
                    let reports = data["report"] as? [String] ?? []
                    self.getBookImage.getImage(bookuid: id) {
                        image in
                        self.bookList.append(ViewModel(id: id, useruid: useruid, name: name, email: email, bookname: bookname, author: author, title: title, content: content, created: created, edited: edited, price: price, exchange: exchange, sell: sell, blocks:blocks, reports: reports, image: image))
                    }
                }
                else if (QueryDocumentSnapshot.type == .removed) {
                    let removeIndex = self.bookList.firstIndex(where: {$0.id == QueryDocumentSnapshot.document.documentID})
                    self.bookList.remove(at: removeIndex!)
                }
            })
        }
    }
}
