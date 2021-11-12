//
//  NeighborGridView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/12.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class NeighborViewModel: ObservableObject {
    @Published var bookModels = [ViewModel]()
    @Published var bookImage = Image(systemName: "book")
    
    func makeList() {
        db.collection("libData").getDocuments() {
            (books, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else {
                guard let books = books?.documents else { return }
                self.bookModels = [ViewModel]()
                for book in books {
                    func getImage(bookuid : String) {
                        Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                            (imageData, err) in
                            if let err = err as NSError? {
                                let randInt = Int.random(in: 0...10)
                                print(err)
                                self.bookModels.append(ViewModel(id: bookuid, useruid: book.get("userid") as! String ,
                                                                 name: book.get("username") as! String,
                                                                 email: book.get("useremail") as! String,
                                                                 bookname: book.get("bookname") as! String,
                                                                 author: book.get("author") as! String,
                                                                 title: book.get("title") as! String,
                                                                 content: book.get("content") as! String,
                                                                 created: (book.get("created") as! Timestamp).dateValue(),
                                                                 edited: (book.get("edited") as! Timestamp).dateValue(),
                                                                 price: book.get("price") as? Int,
                                                                 exchange: book.get("exchange") as! Bool,
                                                                 sell: book.get("sell") as! Bool,
                                                                 image: Image(RandBookImage(rawValue: randInt)!.toString())))
                                }
                        }
                    }
                    getImage(bookuid: book.documentID)
                }
            }
            print(self.bookModels)
        }
        print(bookModels)
    }
}


struct NeighborGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var searchViewModel = SearchViewModel()
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach ( searchViewModel.bookModels.sorted { $0.created!.compare($1.created!) == .orderedDescending} ) {
                        Model in
                        NavigationLink(destination: DetailView(libModel: Model)) {
                            ImageRow(libModel: Model)
                                .frame(width: 200, height: 200)
                                .padding([.top], 5)
                        }
                        .foregroundColor(.black)
                    }
                }
                
                .padding([.leading, .trailing], 10)
                .onAppear(perform: {
                    db = Firestore.firestore()
                    searchViewModel.makeList()
                })
            }
            .navigationBarTitle(Text("Books"))
        }
    }
}

struct NeighborGridView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborGridView()
    }
}
