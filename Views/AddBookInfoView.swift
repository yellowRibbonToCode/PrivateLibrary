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

// useremail username 다시 셋팅해서 가져오기
// 터질까봐 수정안함
// db.collection("users").document(userId).getDocument { (document, err) in
//      if let document = document {
//
//          self.username = document.get("name") as! String
//          self.email = document.get("email") as! String
//        } else {
//          if let err = err {
//              print("Error getting documents: \(err)")
//          }
//        }


struct AddBookInfoView: View {
    
    let userId = Auth.auth().currentUser?.uid ?? "userId"
    
    @State var username : String = " "
    @State var email : String = " "
    @State var author : String = " "
    @State var bookname : String = " "
    @State var title : String = " "
    @State var content : String = " "
    @State var created : Date = Date()
    @State var edited : Date = Date()
    @State var price : Int = 0
    @State var exchange : Bool = false
    @State var sell : Bool = false
    @State var isShowPhotoLibrary = false
    
    @State private var image: UIImage?
    
    private func setuserdb(doc: DocumentReference) {
        db.collection("users").document(userId).getDocument { (document, err) in
            if let document = document {
                
                username = document.get("name") as! String
                email = document.get("email") as! String
                doc.setData([
                    "username": username,
                    "useremail": email
                ], merge: true)
            } else {
                if let err = err {
                    print("Error getting documents: \(err)")
                }
            }
        }
    }
    
    private func setdb() {
//        setuserdb()
        let doc = db.collection("libData")
            .document()
        setuserdb(doc: doc)
        doc.setData([
            "author": author,
            "bookname": bookname,
            "title": title,
            "content": content,
            "created": Date(),
            "edited": Date(),
            "exchange": exchange,
            "price": price,
            "sell": sell,
            "userid": userId], merge: true)
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(doc.documentID)
                //                printdb2()
                
                //upload image
                //                if let thisimage = image{
                //                    upload_Image(image: thisimage, docID: doc.documentID)
                //                }
                
                
                //                setSuccess = true
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
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Button(action:
                {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    
                    Image(systemName: "arrow.left")
                }
                    
            }
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                        .shadow(radius: 10)
                }
                else {
                    VStack {
                        Image(systemName: "plus.app")
                            .font(.system(size: 20))
                        Text("Add Image")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.gray)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1))
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Bookname")
                    .foregroundColor(.gray)
                TextField("Enter the bookname", text: $bookname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Author")
                    .foregroundColor(.gray)
                TextField("Enter the author", text: $author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Title")
                    .foregroundColor(.gray)
                TextField("Enter the title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                Button(action: {
                    exchange = exchange ? false : true
                    
                }) {
                    HStack(alignment: .top, spacing: 10) {
                        
                        Image(systemName: self.exchange ? "checkmark.square" : "square")
                        Text("Exchange")
                    }
                }
                Button(action: {
                    sell = sell ? false : true
                    
                }) {
                    HStack(alignment: .top, spacing: 10) {
                        
                        Image(systemName: self.sell ? "checkmark.square" : "square")
                        Text("Sell")
                    }
                }
            }
            .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Price")
                    .foregroundColor(.gray)
                TextField("Enter the price", value: $price, formatter: NumberFormatter()) //  .string(from: NSNumber(value:price))!
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Content")
                    .foregroundColor(.gray)
                TextField("Enter the content", text: $content)
                    .fixedSize(horizontal: false, vertical: false)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(height: 150)
                    
////                    .padding([.horizontal], 4)
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray).opacity(0.3))
////                    .padding([.horizontal], 24)
            }
            
            Button(action: {
                setdb()
                self.presentationMode.wrappedValue.dismiss()
                
            }) {
                Text("Add New Book")
                    .foregroundColor(.blue)
            }
            .padding()
            Spacer()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                .padding()
                .onAppear(perform: {
                    db = Firestore.firestore()
                })
        }
        .padding(EdgeInsets(top: 20, leading: 40, bottom: 0, trailing: 40))
      
    }
}
struct AddBookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookInfoView()
    }
}
