//
//  ProfileDetailView.swift
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

struct ProfileDetailView : View {
    var libModel: ViewModel
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var tapped: Bool = false
    
    var body : some View{
        ZStack(alignment: .topTrailing){
            VStack{
                
                if let image = libModel.image {
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
                }
                
                
                VStack(alignment: .leading, spacing: 0){
                    profileDetailTop(libModel: libModel)
                    detailMiddle(libModel: libModel)
                    detailBottom(libModel: libModel, tapped: $tapped)
                }
                .background(Color.white)
                .clipShape(Rounded())
                .padding(.top, self.tapped ? -UIScreen.main.bounds.height / 3 : -UIScreen.main.bounds.height / 12)

                
                //            .onAppear(perform: {
                //                books.makebookmarklist()
                //                print("makebookmarklist")
                //            })
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .edgesIgnoringSafeArea(.all)
            //        .onAppear(perform: {
            //            books.makebookmarklist()
            //            print("makebookmarklist")
            //        })
        }
    }
    
    var btnBack : some View
    {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
    }
}


struct profileDetailTop : View {
    var libModel: ViewModel
    @State var selectedItem: Int = 0

    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            Menu {
                Button(action:{
                    selectedItem = 0
                }) {
                    Label("Chat", systemImage: "message.fill")
                }
                Button(action: {
                    selectedItem = 1
                }){
                    Label("Edit", systemImage: "pencil")
                }
                Button(action: {
                    selectedItem = 2
                }){
                    Label("Delete", systemImage: "trash.fill")
                }
                Button(action: {
                    selectedItem = 3
                }){
                    Label("Empty", systemImage: "xmark.circle.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
            .foregroundColor(.mainBlue)
            
        }
        .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
        .font(Font.custom("S-CoreDream-6Bold", size: 33))
        
    }
}
