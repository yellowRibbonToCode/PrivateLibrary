//
//  ImageGridView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/26.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


class SearchViewModel: ObservableObject {
    @Published var bookModels = [ViewModel]()
    @Published private var bookImage : Image?
    
    func getImage(bookuid : String){
        Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
            (imageData, err) in
            if let err = err {
                print("an error has occurred - \(err.localizedDescription)")
            } else {
                if let imageData = imageData {
                    self.bookImage = Image(uiImage: UIImage(data:imageData)!)
                    
                } else {
                    print("an error has occurred")
                }
            }
        }
    }
    
    func makeList() {
        db.collection("libData").getDocuments() {
            (books, err) in
            if let err = err{
                print("Error getting documents: \(err)")
            }
            else {
                guard let books = books?.documents else { return }
                    for book in books {
//                        print(book.get("userid") ?? "no userid")
//                        print(book.get("username") ?? "no username")
//                        print(book.get("useremail") ?? "no useremail")
//                        print(book.get("author") ?? "no author")
//                        print(book.get("title") ?? "no title")
//                        print(book.get("content") ?? "no content")
//
//                        print(book.get("created") ?? "no creatde")
//                        print(book.get("edited") ?? "no edited ")
//                        print(book.get("exchange") ?? "no exchange")
//                        print(book.get("sell") ?? "no sell")
                        self.getImage(bookuid: book.documentID)
                            
                        self.bookModels.append(ViewModel(id: book.get("userid") as! String , name: book.get("username") as! String, email: book.get("useremail") as! String, bookname: book.get("bookname") as! String, author: book.get("author") as! String, title: book.get("title") as! String, content: book.get("content") as! String, created: book.get("created") as! Int, edited: book.get("edited") as! Int, price: book.get("price") as? Int , exchange: book.get("exchange") as! Bool, sell: book.get("sell") as! Bool, image: self.bookImage ?? Image(systemName: "book")))

                }
            }
            print(self.bookModels)
        }
        print(bookModels)
    }
    
    private func printLibData() {
        db.collection("libData").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.documentID)
                    let booklist = db.collection("libData").document(document.documentID)
                    booklist.collection("booklist").getDocuments() { (books, err) in
                        if let err = err {
                            print("error - \(err)")
                        }
                        else {
                            for book in books!.documents {
                                print("\(book.documentID) => \(book.data())")
                            }
                        }
                    }
                    
                }
            }
        }
    }
}
    
    
    
struct ImageGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var searchViewModel = SearchViewModel()
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach ( searchViewModel.bookModels ) {
                        Model in
                        NavigationLink(destination: DetailView(libModel: Model)) {
                            ImageRow(libModel: Model)
                                .frame(width: 200, height: 200)
                                .padding([.top], 5)
                        }
                    }
                    
                }
                .onAppear(perform: {
                    
                    db = Firestore.firestore()
//                    print(SearchViewModel.bookModels)
                    searchViewModel.makeList()
                })
                .padding([.leading, .trailing], 10)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}
