//
//  ProfileBookmarkDetailView.swift
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

struct ProfileBookmarkDetailView : View {
    var libModel: ViewModel
    @ObservedObject var books: ProfileScene.BookLists

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
                    detailTop(libModel: libModel)
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
            .navigationBarItems(leading: btnBack, trailing: ProfileViewButton(bookmark: checkbookmark(), libModel: libModel, books: books)
            )
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
    
    private func checkbookmark() -> Bool {
        
        if books.bookmarkarray.contains(self.libModel.id) {
            return true
        }
        else
        {
            return false
        }
    }
}
