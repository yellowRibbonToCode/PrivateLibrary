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
    //author
    //bookname
    //title
    //content
    //created
    //edited
    //exchange
    //price
    //sell
    
    @State var username : String = " "
    @State var email : String = " "
    @State var author : String = " "
    @State var bookname : String = " "
    @State var title : String = " "
    @State var content : String = " "
    @State var created : Timestamp = Timestamp(date: Date())
    @State var edited : Timestamp = Timestamp(date: Date())
    @State var price : String = " "
    @State var exchange : Bool = false
    @State var sell : Bool = false
    @State var setSuccess = false
    @State var isShowPhotoLibrary = false
    @State var changeOn = false
    @State var sellOn = false
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
            "author": author,
            "bookname": bookname,
            "title": title,
            "content": content,
            "created": Timestamp(date: Date()),
            //edited
            "exchange": exchange,
            "price": price,
            "sell": sell
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
                        Button(action: {
                            self.isShowPhotoLibrary = true
                        }) {
                            if uploadImage != nil {
                                Image(uiImage: uploadImage!)
                                    .resizable()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                                    .cornerRadius(20)
                            }
                            else {
                                VStack {
                                    Image(systemName: "plus.app")
                                        .font(.system(size: 20))
                                    Text("Add Image")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .padding(.horizontal)
                            }
                        }
                        HStack {
                            Text("bookname")
                            
                            TextField("bookname", text: $bookname)
                                .frame(width: 230, height: 20)
                                .textFieldStyle(.roundedBorder)
                        }
                        HStack {
                            Text("author")
                            
                            TextField("author", text: $author)
                                .frame(width: 230, height: 20)
                                .textFieldStyle(.roundedBorder)
                        }
                        HStack {
                            Text("title")
                            
                            TextEditor(text: $title)
                                .frame(width: 230, height: 40)
                                .textFieldStyle(.roundedBorder)
                        }
                        HStack {
                            Text("price")
                            
                            TextField("price", text: $price)
                                .frame(width: 230, height: 40)
                                .textFieldStyle(.roundedBorder)
                        }
                        HStack{
                            Button(action: {
                                exchange = true
                                changeOn = changeOn ? false : true
                                
                            }) {
                                HStack(alignment: .top, spacing: 10) {
                                    
                                    Rectangle()
                                        .fill(changeOn ? Color.black : Color.white)
                                        .frame(width:20, height:20, alignment: .center)
                                        .cornerRadius(5)
                                    Text("Exchange")
                                }
                            }
                            Button(action: {
                                sell = true
                                sellOn = sellOn ? false : true
                            }) {
                                HStack(alignment: .top, spacing: 10) {
                                    
                                    Rectangle()
                                        .fill(sellOn ? Color.black : Color.white)
                                        .frame(width:20, height:20, alignment: .center)
                                        .cornerRadius(5)
                                    Text("Sell")
                                }
                            }
                            
                        }
                        ZStack (alignment: .bottomTrailing){
                            TextEditor(text: $content)
                                .lineSpacing(10)
                                .frame(width: 230, height: 200)
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
                            printdb()
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
