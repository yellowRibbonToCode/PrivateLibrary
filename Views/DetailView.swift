//
//  SearchDetailView.swift
//  동네북
//
//  Created by SSB on 2021/11/13.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct DetailView : View {
    var libModel: ViewModel
//    var showBookmark: Bool = true
    let useruid = Auth.auth().currentUser!.uid
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var startingOffsetY: CGFloat = -UIScreen.main.bounds.height / 12
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    
    var body : some View{
        ZStack(alignment: .topTrailing){
            VStack{
                if let image = libModel.image {
                    image
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
                }
//                    VStack{
//                        Text("\(startingOffsetY)")
//                        Text("\(currentDragOffsetY)")
//                        Text("\(endingOffsetY)")
//                    }
                
                VStack(alignment: .leading, spacing: 0){
                    if libModel.useruid != useruid {
                        detailTop(libModel: libModel)
                    }
                    else {
                        profileDetailTop(libModel: libModel)
                    }
                    
                    detailMiddle(libModel: libModel)
                    detailBottom(libModel: libModel)
                }
                .background(Color.white)
                .clipShape(Rounded())
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
                                    endingOffsetY = -UIScreen.main.bounds.height / 3 + UIScreen.main.bounds.height / 12
                                } else if endingOffsetY != 0 && currentDragOffsetY > 100 {
                                    endingOffsetY = 0
                                }
                                currentDragOffsetY = 0
                            }
                        }
                )
                
                
                
            }
            .navigationBarBackButtonHidden(true)
            
            .navigationBarItems(leading: btnBack, trailing: BookMarkButton(bookuid: libModel.id))
            
            .edgesIgnoringSafeArea(.all)
            
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

struct detailTop : View {
    var libModel: ViewModel
    @State var selectedItem: Int? = 0
    @State var showConfirm = false
    @State var blockConfirm = false
    @State var reportConfirm = false
    private let userid = Auth.auth().currentUser!.uid

    
    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            NavigationLink(destination: MakeChat(other: libModel.useruid), tag: 1, selection: $selectedItem) {
                EmptyView()
            }
            Button(action: {
                showConfirm = true
            }, label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.mainBlue)
            })
            
            .confirmationDialog("", isPresented: $showConfirm) {
                Button("대화하기") {
                    selectedItem = 1
                }
                Button("차단하기", role: .destructive) {
                    blockConfirm = true
                }
                Button("신고하기", role: .destructive) {
                    reportConfirm = true
                }
                Button("취소", role:.cancel) {
                }
            }
            .confirmationDialog("차단하시겠습니까?", isPresented: $blockConfirm, titleVisibility: .visible) {
                Button("네", role: .destructive) {
                    updateBlock()
                }
                Button("아니오", role:.cancel) {
                }
            }
            
            .confirmationDialog("신고하시겠습니까?", isPresented: $reportConfirm, titleVisibility: .visible) {
                Button("네", role: .destructive) {
                    updatereportdb()
                }
                Button("아니오", role: .cancel) {
                }
            }
                        
        }
        .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
        .font(Font.custom("S-CoreDream-6Bold", size: 33))
        
    }
    
    
    private func updatereportdb() {
        db = Firestore.firestore()
        let doc = db.collection("libData").document(libModel.id)
        doc.updateData([
            "report" : FieldValue.arrayUnion([userid])
        ])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private func updateBlock() {
        db = Firestore.firestore()
        let doc = db.collection("libData").document(libModel.id)
        doc.updateData([
            "blocks" : FieldValue.arrayUnion([userid])
        ])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}


struct profileDetailTop : View {
    var libModel: ViewModel
    @State var showAdd = false
    @State var showConfirm = false
    private let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            Button(action: {
                showConfirm = true
            }, label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.mainBlue)
            })
            
            .confirmationDialog("", isPresented: $showConfirm) {
                Button("게시글 수정") {
                    self.showAdd.toggle()
                }
                Button("게시글 삭제", role: .destructive) {
                    deletedb()
                    self.presentationMode.wrappedValue.dismiss()
                }
                Button("취소", role:.cancel) {
                }
            }
        }
        .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
        .font(Font.custom("S-CoreDream-6Bold", size: 33))
        .fullScreenCover(isPresented: $showAdd) {
               EditBookInfoView(libModel: libModel)

           }
        
    }
    
    private func deletedb() {
        storage.reference().child("images/books/\(libModel.id)").delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("storage successfully removed!")
            }
        }
        
        
        
        db.collection("libData").document(libModel.id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
        
        
        
    }
}


struct detailMiddle : View {
    var libModel: ViewModel
    
    var body : some View{
        
        VStack (spacing: 0) {
            
            HStack {
                Text(libModel.author)
                    .font(Font.custom("S-CoreDream-6Bold", size: 20))
                Spacer()
            }
            HStack {
                Image("doublequoteleft")
                Text(libModel.title)
                    .font(Font.custom("S-CoreDream-6Bold", size: 18))
                    .padding(.horizontal, 34)
                Image("doublequoterightbottom")
                
            }
            .frame(height: UIScreen.main.bounds.height / 9)
            .foregroundColor(.mainBlue)
        }
        .padding(.horizontal)
    }
}

struct detailBottom : View {
    var libModel: ViewModel
    
    var body : some View{
        HStack {
            Text("\(libModel.name)의 시선")
                .font(Font.custom("S-CoreDream-6Bold", size: 16))
                .foregroundColor(.mainBlue)
            Spacer()
        }.padding(EdgeInsets(top: 0, leading: 16, bottom: 3, trailing: 16))
        ScrollView{
            ZStack (alignment: .leading){
                Text("\(libModel.content)")
                    .font(Font.custom("S-CoreDream-3Light", size: 15))
                    .padding()
                    .lineSpacing(3)
                Rectangle()
                    .fill(Color(red: 0.745, green: 0.745, blue: 0.745, opacity: 0.15))
                    .clipShape(contentRounded())
            }.padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))

        }
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 40, height: 40))
        return Path(path.cgPath)
    }
}

struct contentRounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 40, height: 40))
        return Path(path.cgPath)
    }
}

struct ArrowShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let center = rect.width / 2
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: center - 15, y: rect.height - 20))
            path.addLine(to: CGPoint(x: center, y: rect.height))
            path.addLine(to: CGPoint(x: center + 15, y: rect.height - 20))
            
            path.addLine(to: CGPoint(x: 0, y: rect.height - 20))
        }
    }
}

