//
//  AddBookInfoView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/01.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct AddBookInfoView: View {
    
    let userId = Auth.auth().currentUser?.uid ?? "userId"
    @State var username : String = " "
    @State var email : String = " "
    @State var bookname : String = " "
    @State var subtitle : String = " "
    @State var content : String = " "
    @State var setSuccess = false
    
    
    
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
    private func printdb2() {
        
        db.collection("libData")
            .document(userId)
            .collection("booklist")
            .getDocuments{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                    }
                }
            }
    }
    
    private func setdb() {
        db.collection("libData")
            .document(userId)
            .collection("booklist")
            .document().setData([
                "bookname": bookname,
                "subtitle": subtitle,
                "content": content
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    printdb2()
                    setSuccess = true
                }
            }
        
    }
    
    var body: some View {
        if setSuccess {
            HomeView()
        }
        else{
            HStack {
                Spacer()
                VStack{
                    Spacer()
                    VStack {
                        Text("bookname")
                        TextField("bookname", text: $bookname)
                            .frame(width: 230, height: 20)
                            .textFieldStyle(.roundedBorder)
                        Text("subtitle")
                        TextEditor(text: $subtitle)
                            .frame(width: 230, height: 70)
                            .textFieldStyle(.roundedBorder)
                        Text("content")
                        ZStack (alignment: .bottomTrailing){
                            TextEditor(text: $content)
                                .lineSpacing(10)
                                .frame(width: 230, height: 200)
                        }
                    }
                    .padding()
                    .onAppear(perform: {
                        db = Firestore.firestore()
                        printdb()
                    })
                    Button(action: {
                        setdb()
                        
                    }, label: {
                        Text("set")
                    })
                        .padding()
                    Spacer()
                }
                Spacer()
            }
            
            .background(Color.gray.opacity(0.5).cornerRadius(10))
            .ignoresSafeArea()
        }
    }
    
}
struct AddBookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookInfoView()
    }
}
