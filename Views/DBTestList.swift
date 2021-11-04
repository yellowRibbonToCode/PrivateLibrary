//
//  DBTestList.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/30.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

var db: Firestore!

class StorageManager: ObservableObject {
    let storage = Storage.storage()
}

private func addAdaLovelace() {
    // [START add_ada_lovelace]
    // Add a new document with a generated ID
    var ref: DocumentReference? = nil
    ref = db.collection("users").addDocument(data: [
        "first": "Ada",
        "last": "Lovelace",
        "born": 1815
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref!.documentID)")
        }
    }
    // [END add_ada_lovelace]
}

private func addAlanTuring() {
    var ref: DocumentReference? = nil
    
    // [START add_alan_turing]
    // Add a second document with a generated ID.
    ref = db.collection("users").addDocument(data: [
        "first": "Alan",
        "middle": "Mathison",
        "last": "Turing",
        "born": 1912
    ]) { err in
        if let err = err {
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref!.documentID)")
        }
    }
    // [END add_alan_turing]
}
private func getCollection() {
    // [START get_collection]
    db.collection("libData").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
    // [END get_collection]
}

struct DBTestList: View {
    //    db = Firestore.firestore()
    let userId = Auth.auth().currentUser?.uid ?? "userId"
    //    var username = db.collection("libData").document(userId).getDocument(source: .cache)
    @State var username : String = " "
    @State var email : String = " "
    private func printdb() {
        
        db.collection("libData").document(userId).getDocument { (document, err) in
            if let document = document {
                print(userId)
                print(document)
                print(document.get("name") ?? " ")
                print(document.get("email") ?? " ")
                print(document.data()?["name"] ?? " ")
                self.username = document.get("name") as! String
                self.email = document.get("email") as! String
            } else {
                if let err = err {
                    print("Error getting documents: \(err)")
                }
            }
        }
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
    
var body: some View {
    
    VStack{
        Text(userId as String)
        //            Button(action: {
        //                printdb()
        //            }, label:
        //                    {
        //                Text("printdb")
        //            })
        Text(username)
        Text(email)
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
            .onAppear(perform: {
                
                db = Firestore.firestore()
//                printdb()
//                getCollection()
                printLibData()
            })
    }
}
}

struct DBTestList_Previews: PreviewProvider {
    static var previews: some View {
        DBTestList()
    }
}
