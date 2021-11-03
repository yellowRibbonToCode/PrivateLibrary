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
    @State var isShowPhotoLibrary = false
    @State private var uploadImage : UIImage?
    
    
    
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
        let doc = db.collection("libData")
            .document(userId)
            .collection("booklist")
            .document()
        doc.setData([
            "bookname": bookname,
            "subtitle": subtitle,
            "content": content
        ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(doc.documentID)
                printdb2()
                
                //upload image
                if let thisimage = uploadImage{
                    upload_Image(image: thisimage, docID: doc.documentID)
                }
                
                
                setSuccess = true
            }
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func upload_Image(image:UIImage, docID: String){
        let image : UIImage = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child("images/books/\(docID)").putData(imageData, metadata: nil){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                }
            }
        } else {
            print("coldn't unwrap/case image to data")
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
                        
                        if uploadImage != nil {
                            Image(uiImage: uploadImage!)
                                .resizable()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: 300, height: 300)
                        }
                        
                        
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
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            HStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 20))
                                
                                Text("Photo library")
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        }
                        
                    }
                    
                    
                        Button(action: {
                            setdb()
                            
                        }, label: {
                            Text("set")
                        })
                            .padding()
                        Spacer()
                    }
                .sheet(isPresented: $isShowPhotoLibrary) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$uploadImage)
                        .padding()
                        .onAppear(perform: {
                            db = Firestore.firestore()
//                            printdb()
                        })
                    Spacer()
                }
                
                .background(Color.gray.opacity(0.5).cornerRadius(10))
                .ignoresSafeArea()
            }
        }
    }
}
struct AddBookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookInfoView()
    }
}
