//
//  MakeListModel.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/06.
//
import SwiftUI

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SushinViewModel: ObservableObject {
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
                                let randInt = Int.random(in: 0...10)
                                
                                //                                print("an error has occurred - \(err.localizedDescription)")
                                //                                if (StorageErrorCode(rawValue: err.code) == .objectNotFound) {
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
                            //                            } else {
                            //                                if let imageData = imageData {
                            //                                    self.bookImage = Image(uiImage: UIImage(data:imageData)!)
                            //                                    print("getdata: \(imageData)")
                            //                                    self.bookModels.append(ViewModel(id: book.get("userid") as! String , name: book.get("username") as! String, email: book.get("useremail") as! String, bookname: book.get("bookname") as! String, author: book.get("author") as! String, title: book.get("title") as! String, content: book.get("content") as! String, created: book.get("created") as! Int, edited: book.get("edited") as! Int, price: book.get("price") as? Int , exchange: book.get("exchange") as! Bool, sell: book.get("sell") as! Bool, image: self.bookImage))
                            //                                } else {
                            //                                    print("an error has occurred")
                            //                                }
                            //                            }
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
