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

class MySearchViewModel: ObservableObject {
    @Published var bookModels = [ViewModel]()
    @Published var bookImage = Image(systemName: "book")
    private let uid = Auth.auth().currentUser!.uid
    
    func makeList() {
        db.collection("libData").whereField("userid", isEqualTo: uid).getDocuments() {
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
                    //                        self.getImage(bookuid: book.documentID)
                    func getImage(bookuid : String) {
                        Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                            (imageData, err) in
                            if let err = err as NSError? {
                                print("an error has occurred - \(err.localizedDescription)")
                                if (StorageErrorCode(rawValue: err.code) == .objectNotFound) {
                                    self.bookModels.append(ViewModel(id: bookuid, useruid: book.get("userid") as! String , name: book.get("username") as! String, email: book.get("useremail") as! String, bookname: book.get("bookname") as! String, author: book.get("author") as! String, title: book.get("title") as! String, content: book.get("content") as! String, created: book.get("created") as? Date, edited: book.get("edited") as? Date, price: book.get("price") as? Int , exchange: book.get("exchange") as! Bool, sell: book.get("sell") as! Bool, image: Image(systemName: "book")))
                                }
                            } else {
                                if let imageData = imageData {
                                    self.bookImage = Image(uiImage: UIImage(data:imageData)!)
                                    print("getdata: \(imageData)")
                                    self.bookModels.append(ViewModel(id: bookuid, useruid: book.get("userid") as! String , name: book.get("username") as! String, email: book.get("useremail") as! String, bookname: book.get("bookname") as! String, author: book.get("author") as! String, title: book.get("title") as! String, content: book.get("content") as! String, created: book.get("created") as? Date, edited: book.get("edited") as? Date, price: book.get("price") as? Int , exchange: book.get("exchange") as! Bool, sell: book.get("sell") as! Bool, image: self.bookImage))
                                } else {
                                    print("an error has occurred")
                                }
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

struct MyImageGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var mysearchViewModel = MySearchViewModel()
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach ( mysearchViewModel.bookModels ) {
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
                    mysearchViewModel.makeList()
                })
                .padding([.leading, .trailing], 10)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}

struct MyImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        MyImageGridView()
    }
}