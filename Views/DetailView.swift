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
    var showBookmark: Bool = true
    
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
                    if showBookmark {
                        detailTop(libModel: libModel)
                    }
                    else {
                        profileDetailTop(libModel: libModel)
                    }
                    
                    detailMiddle(libModel: libModel)
                    detailBottom(libModel: libModel, tapped: $tapped)
                }
                .background(Color.white)
                .clipShape(Rounded())
                .padding(.top, self.tapped ? -UIScreen.main.bounds.height / 3 : -UIScreen.main.bounds.height / 12)
                
                
            }
            .navigationBarBackButtonHidden(true)
            
            .navigationBarItems(leading: btnBack, trailing: (showBookmark == true ? BookMarkButton(bookuid: libModel.id) : nil))
            
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
    
    
    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            NavigationLink(destination: MakeChat(other: libModel.useruid), tag: 1, selection: $selectedItem) {
                EmptyView()
            }
            
            Menu {
                Button(action:{
                    selectedItem = 1
                    
                    
                }) {
                    Label("Chat", systemImage: "message.fill")
                }
                
            } label: {
                Image(systemName: "ellipsis")}
            
            .foregroundColor(.mainBlue)
            
        }
        .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
        .font(Font.custom("S-CoreDream-6Bold", size: 33))
        
    }
}


struct profileDetailTop : View {
    var libModel: ViewModel
    
    @State var showAdd = false
    
    private let db = Firestore.firestore()
    let storage = Storage.storage()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            Menu {
                Button(action: {
                    self.showAdd.toggle()
                }) {
                    Label("Edit", systemImage: "pencil")
                }
    
                Button(action: {
                    deletedb()
                    self.presentationMode.wrappedValue.dismiss()
                    
                }){
                    Label("Delete", systemImage: "trash.fill")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
            .foregroundColor(.mainBlue)
            
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
    @Binding var tapped: Bool
    
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
                .onTapGesture {
                    withAnimation(.spring()) {
                        self.tapped.toggle()
                    }
                }
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

