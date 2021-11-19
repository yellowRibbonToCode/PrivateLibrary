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
    
    @State var username : String = ""
    @State var email : String = ""
    @State var author : String = ""
    @State var bookname : String = ""
    @State var title : String = ""
    @State var content : String = ""
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
        db = Firestore.firestore()
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
                if let thisimage = image{
                    upload_Image(image: thisimage, docID: doc.documentID)
                }
                
                
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
    @State var tapped: Bool = false
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
     
        VStack {
            ZStack(alignment: .topLeading){
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
                }
                else {
                    
                    Image("plus-w")
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
                        .background(Color.black.opacity(0.29))
                    
                }
            }
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.left")
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(.white)
                                    .font(.system(size: 25))
                                    .frame(width: 70, height: 70)
                            }
                            .padding(.top, 16)
            }
            
            VStack(alignment: .leading, spacing: 0){
                // Top
                TextField("도서명", text: $bookname)
                    .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
                    .font(Font.custom("S-CoreDream-6Bold", size: 33))
                HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                    .padding(.leading, 16).offset(y: -10)

                
                
                // Middle
                
                VStack (spacing: 0) {
                    VStack(alignment: .leading){
                    HStack {
                        TextField("작가", text: $author)
                            .font(Font.custom("S-CoreDream-6Bold", size: 20))
                        Spacer()
                    }
                    HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                    .offset(y: -10)}
                    HStack {
                        Image(systemName: "quote.opening")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .padding(.bottom, UIScreen.main.bounds.height / 18)
                        VStack{
                        TextField("제목을 입력해 주세요.", text: $title)
                            .font(Font.custom("S-CoreDream-6Bold", size: 18))
                            .padding(.horizontal, 34).multilineTextAlignment(.center)
                        HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                        .padding(.leading, 16).offset(y: -10)}
                        Image(systemName: "quote.closing")
                            .resizable()
                            .frame(width: 20, height: 15)
                            .padding(.top, UIScreen.main.bounds.height / 18)
                    }                .padding(.horizontal, 10)
                    
                        .frame(height: UIScreen.main.bounds.height / 9)
                        .foregroundColor(.mainBlue)
                }
                .padding(.horizontal)
                
                // Bottom
                
                HStack {
                    Text("Username의 시선")
                        .font(Font.custom("S-CoreDream-6Bold", size: 16))
                        .foregroundColor(.mainBlue)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 3, trailing: 16))
                ScrollView{
                    ZStack(alignment: .topLeading) {
                        if content.isEmpty {
                            Text("내용을 입력해 주세요.")
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .padding()
                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 16, trailing: 16))
                        .foregroundColor(Color.gray)
                        }
                TextEditor(text: $content)
                    .font(Font.custom("S-CoreDream-3Light", size: 15))
                    .padding()
                    .lineSpacing(3)
                    .background(Color(red: 0.745, green: 0.745, blue: 0.745, opacity: 0.15))
                    .clipShape(contentRounded())
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                }           .onTapGesture {
                    withAnimation(.spring()) {
                        self.tapped.toggle()
                    }
                }
                    Button(action: {
                        setdb()
                        self.presentationMode.wrappedValue.dismiss()

                    }) {
                        Text("작성 완료")
                            .frame(width: UIScreen.main.bounds.width / 1.7, height: 35)
                            .background(Color.white)
                            .cornerRadius(20)
                            .foregroundColor(.mainBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.mainBlue, lineWidth: 2.5)
                            )
                    }
                    .padding()

                }
            }
            .background(Color.white)
            .clipShape(Rounded())
            .padding(.top, self.tapped ? -UIScreen.main.bounds.height / 2.7 : -UIScreen.main.bounds.height / 12)
                        
        }
        
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                .padding()
                .onAppear(perform: {
                    db = Firestore.firestore()
                })
        }
        
        
        .edgesIgnoringSafeArea(.all)
        
        
    }
    
//        var btnBack : some View
//        {
//            Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "arrow.left")
//                    .aspectRatio(contentMode: .fit)
//                    .foregroundColor(.white)
//            }
//        }
}

struct HorizontalLineShape: Shape {

    func path(in rect: CGRect) -> Path {

        let fill = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        var path = Path()
        path.addRoundedRect(in: fill, cornerSize: CGSize(width: 2, height: 2))

        return path
    }
}

struct HorizontalLine: View {
    private var color: Color? = nil
    private var height: CGFloat = 1.0

    init(color: Color, height: CGFloat = 1.0) {
        self.color = color
        self.height = height
    }

    var body: some View {
        HorizontalLineShape().fill(self.color!).frame(minWidth: 0, maxWidth: UIScreen.main.bounds.width / 1.5, minHeight: height, maxHeight: height)
    }
}

struct AddBookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookInfoView()
    }
}
