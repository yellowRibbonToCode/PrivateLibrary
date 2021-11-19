//
//  NeighborImageRow.swift
//  동네북
//
//  Created by sushin on 2021/11/19.
//


import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct  NeighborViewButton: View {
    @State var bookmark: Bool
    var libModel: ViewModel
    @ObservedObject var books: NeighborViewModel
    
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
                Image("bookmark-p")

            }
            else {
                Image("bookmark-p-blank-small")

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
                    doc.document("\(document.documentID)").delete()
                }
                if let i = self.books.bookmarkarray.firstIndex(of: libModel.id) {
                    self.books.bookmarkarray.remove(at: i)
                }
            }
            
        })
        
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
                self.books.bookmarkarray.append(doc.documentID)
            }
        }
        
    }
}

struct NeighborImageRow: View {
    var libModel: ViewModel
    @ObservedObject var books: NeighborViewModel
    
    
    
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
                NeighborViewButton(bookmark: checkbookmark(), libModel: libModel, books: books)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                
            }
            HStack {
                if libModel.bookname.count > 15 {
                    Text(libModel.bookname.prefix(14) + "…")
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
                else {
                    Text(libModel.bookname)
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                    
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
            }
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(height: 45, alignment: .topLeading)
            .truncationMode(.tail)
        }
    }
    
    private func checkbookmark() -> Bool {
        
        if self.books.bookmarkarray.contains(self.libModel.id) {
            return true
        }
        else
        {
            return false
        }
    }
    
}
