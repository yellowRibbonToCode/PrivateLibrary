//
//  DBTestList.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/30.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift

var db: Firestore!


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
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    
        .onAppear(perform: {
            db = Firestore.firestore()
            getCollection()
        })
    }
    
}

struct DBTestList_Previews: PreviewProvider {
    static var previews: some View {
        DBTestList()
    }
}
