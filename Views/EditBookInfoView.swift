//
//  EditBookInfoView.swift
//  동네북
//
//  Created by sushin on 2021/11/22.
//

import SwiftUI

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct EditBookInfoView: View {
    
    @State var libModel: ViewModel
    
    let userId = Auth.auth().currentUser?.uid ?? "userId"
    
    @State var startingOffsetY: CGFloat = -UIScreen.main.bounds.height / 12
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    
    @FocusState private var nameIsFocused: Bool
    
    @State var isShowPhotoLibrary = false
    
    @State private var image: UIImage?
    
    
    private func updatedb() {
        db = Firestore.firestore()
        let doc = db.collection("libData").document(libModel.id)
        doc.updateData([
            "author": libModel.author,
            "bookname": libModel.bookname,
            "title": libModel.title,
            "content": libModel.content,
            "edited": Date(),
            "exchange": libModel.exchange,
            "price": libModel.price!,
            "sell": libModel.sell,
            
        ])
        { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print(doc.documentID)
                
                //upload image
                if let thisimage = image{
                    upload_Image(image: thisimage, docID: doc.documentID)
                }
                
                
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
    
    //    init() {
    //        UITextView.appearance().backgroundColor = .clear
    //    }
    
    var body: some View {
        
        VStack {
            ZStack(alignment: .topLeading){
                Button(action: {
                    self.isShowPhotoLibrary = true
                }) {
                    libModel.image
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
                        .background(Color.black.opacity(0.29))
                    
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
                TextField(libModel.bookname, text: $libModel.bookname )
                    .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
                    .font(Font.custom("S-CoreDream-6Bold", size: 33))
                HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                    .padding(.leading, 16).offset(y: -10)
                
                
                
                // Middle
                
                VStack (spacing: 0) {
                    VStack(alignment: .leading){
                        HStack {
                            TextField(libModel.author, text: $libModel.author)
                                .font(Font.custom("S-CoreDream-6Bold", size: 20))
                            Spacer()
                        }
                        HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                        .offset(y: -10)}
                    HStack {
                        Image("doublequoteleft")
                        
                        VStack{
                            TextField(libModel.title, text: $libModel.title)
                                .font(Font.custom("S-CoreDream-6Bold", size: 18))
                                .padding(.horizontal, 34).multilineTextAlignment(.center)
                            HorizontalLine(color: Color(red: 0.725, green: 0.725, blue: 0.725, opacity: 1))
                            .padding(.leading, 16).offset(y: -10)}
                        Image("doublequoterightbottom")
                        
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
                        if libModel.content.isEmpty {
                            Text("내용을 입력해 주세요.")
                                .font(Font.custom("S-CoreDream-3Light", size: 15))
                                .padding()
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 16, trailing: 16))
                                .foregroundColor(Color.gray)
                        }
                        TextEditor(text: $libModel.content)
                            .font(Font.custom("S-CoreDream-3Light", size: 15))
                            .padding()
                            .lineSpacing(3)
                            .background(Color(red: 0.745, green: 0.745, blue: 0.745, opacity: 0.15))
                            .clipShape(contentRounded())
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                    }
                    Button(action: {
                        updatedb()
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Text("수정 완료")
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
//            .padding(.top, self.tapped ? -UIScreen.main.bounds.height / 2.7 : -UIScreen.main.bounds.height / 12)
            .padding(.top, startingOffsetY)
            .padding(.top, currentDragOffsetY)
            .padding(.top, endingOffsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.spring()) {
                            currentDragOffsetY = value.translation.height
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring()) {
                            if currentDragOffsetY < -100 {
                                endingOffsetY = -UIScreen.main.bounds.height / 2.7 + UIScreen.main.bounds.height / 12
                            } else if endingOffsetY != 0 && currentDragOffsetY > 100 {
                                endingOffsetY = 0
                            }
                            currentDragOffsetY = 0
                        }
                    }
            )
            .onTapGesture {
                nameIsFocused = false
            }
            
        }
        .disableAutocorrection(true)
        .focused($nameIsFocused)

        
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
                .padding()
                .onAppear(perform: {
                    db = Firestore.firestore()
                })
        }
        
        
        .edgesIgnoringSafeArea(.all)
        
        
    }
    
}
