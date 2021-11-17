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
struct SearchDetailView : View {
    var libModel: ViewModel
    @ObservedObject var books: TestBookmarkView.BookLists
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var popshow: Bool = false
    @State var tapped: Bool = false
    
    var body : some View{
        
        VStack{
            if let image = libModel.image {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.48)
            }
            VStack(alignment: .leading, spacing: 0){
                detailTop(libModel: libModel, popshow: $popshow)
                detailMiddle(libModel: libModel)
                detailBottom(libModel: libModel)
            }
            .background(Color.white)
            .clipShape(Rounded())
            .padding(.top, self.tapped ? -UIScreen.main.bounds.height / 3 : -UIScreen.main.bounds.height / 12)
            .onTapGesture {
                withAnimation(.spring()) {
                    self.tapped.toggle()
                }
            }
//            .onAppear(perform: {
//                books.makebookmarklist()
//                print("makebookmarklist")
//            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack, trailing: TestBookmarkViewButton(bookmark: checkbookmark(), libModel: libModel, books: books)
)
        .edgesIgnoringSafeArea(.all)
//        .onAppear(perform: {
//            books.makebookmarklist()
//            print("makebookmarklist")
//        })
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

struct detailTop : View {
    var libModel: ViewModel
    @Binding var popshow: Bool
    
    var body : some View{
        
        HStack {
            Text(libModel.bookname)
            Spacer()
            VStack{
                if self.popshow {
                    popOver()
                        .background(Color.mainBlue)
                        .clipShape(ArrowShape())
                        .cornerRadius(15)
                        .offset(y: 15)
                }
                Button(action : {
                    withAnimation(.spring()) {
                        self.popshow.toggle()
                    }
                }) {
                    Text("…")
                        .foregroundColor(.mainBlue)
                }
            }
        }
        .padding(EdgeInsets(top: 36, leading: 16, bottom: 10, trailing: 32))
        .font(Font.custom("S-CoreDream-6Bold", size: 33))
        
    }
}

struct popOver : View {
    
    var body : some View {
        
        VStack(alignment: .leading, spacing: 18) {
            
            Button(action: {
                
            }) {
                
                HStack(spacing: 15) {
                    
                    Image(systemName: "circle.fill")
                        .renderingMode(.original)
                    Text("chat")
                }
            }
            
            Divider()
            
            Button(action: {
                
            }) {
                
                HStack(spacing: 15) {
                    
                    Image(systemName: "circle.fill")
                        .renderingMode(.original)
                    Text("chat")
                }
            }
            
            Divider()
            
            Button(action: {
                
            }) {
                
                HStack(spacing: 15) {
                    
                    Image(systemName: "circle.fill")
                        .renderingMode(.original)
                    Text("chat")
                }
            }
        }
        .foregroundColor(.black)
        .frame(width: 140)
        .padding()
        .padding(.bottom, 20)
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
                Image(systemName: "quote.opening")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .padding(.bottom, UIScreen.main.bounds.height / 18)
                Text(libModel.title)
                    .font(Font.custom("S-CoreDream-6Bold", size: 18))
                    .padding(.horizontal, 34)
                Image(systemName: "quote.closing")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .padding(.top, UIScreen.main.bounds.height / 18)
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


//struct SearchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sushin = ViewModel( id: "id",  useruid: "useruid", name: "sushin", email: "email", bookname: "보통의 노을", author: "이희영", title: "가장 보통의, 가장 사소한 이야기", content: "주며, 원대하고, 만물은 청춘 영락과 있음으로써 뿐이다. 더운지라 천하를 붙잡아 그와 아니다. 구하지 인도하겠다는 인생의 청춘 일월과 때문이다. 그것은 가장 간에 길지 위하여서 바이며, 유소년에게서 것은 어디 이것이다. 같은 따뜻한 보내는 보라. 그들은 위하여, 따뜻한 있다. 곧 같은 열락의 청춘의 가는 듣기만 이상의 청춘을 갑 있다.                                                                                   \n\n가는 낙원을 바로 같이, 그들을 별과 시들어 황금시대의 약동하다. 부패를 이상은 구할 그들은 청춘의 있는 그것을 약동하다. 가슴에 그들은 곧 있다. 꾸며 되는 그들은 인간은 피다. 장식하는 부패를 듣기만 운다. 속에 위하여, 바로 가치를 얼음에 할지니, 것이다. 이상은 위하여, 사람은 그들은 새 그들의 황금시대다. 것은 것은 품고 천자만홍이 없으면, 것이다. 같이, 전인 이것이야말로 찬미를 역사를 것은 그들의 보라. 피어나는 하는 무한한 동력은 커다란 같이, 무엇을 이상의 보라. 소리다.이것은 부패를 때까지 남는 거선의 약동하다. 굳세게 것이다.보라, 소금이라 이상을 어디 않는 인생을 대중을 것이다. \n\n그들의 트고, 거친 너의 대중을 가진 되는 교향악이다. 역사를 가치를 보내는 인생을 꽃 가치를 보라. 새가 같이 소금이라 풀밭에 아니더면, 가장 그리하였는가? 넣는 끓는 얼마나 가는 봄바람이다. 이상의 황금시대를 놀이 눈에 청춘 무엇을 따뜻한 그들은 우리 약동하다. 황금시대의 피가 용감하고 굳세게 그것을 못할 우리 가슴에 찾아 부패뿐이다. 온갖 청춘을 안고, 거친 몸이 이상 날카로우나 천자만홍이 사막이다. 꽃 피어나는 못할 것이 있는 용감하고 뿐이다. 인간은 새가 원질이 방황하여도, 것이다. 살 원질이 아니더면, 과실이 아니한 뛰노는 두기 위하여, 있으랴? 넣는 따뜻한 모래뿐일 아니다.", created: Date(), edited: Date(), price: 12, exchange: false, sell: true, image: Image("chilkoottrail"), index: 0)
//        SearchDetailView(libModel: sushin)
//    }
//}

//
//extension SearchDetailView {
//
//    class BookLists: ObservableObject {
//        let userId = Auth.auth().currentUser?.uid ?? "userId"
//        @Published var bookList: [ViewModel] = []
//        @Published var bookmarkarray: [String] = []
//        //    private var bookImage = UIImage(systemName: "book")
//        //        private let userid = Auth.auth().currentUser!.uid
//        private let db = Firestore.firestore()
//
//        func loadBooks() {
//            db.collection("libData").getDocuments() { books, err in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    guard let books = books?.documents else {
//                        print("books is nil")
//                        return
//                    }
//                    var ind: Int = 0
//                    for book in books {
//                        self.bookList.append(ViewModel(
//                            id: book.documentID,
//                            useruid: book.get("userid") as! String,
//                            name: book.get("username") as! String,
//                            email: book.get("useremail") as! String,
//                            bookname: book.get("bookname") as! String,
//                            author: book.get("author") as! String,
//                            title: book.get("title") as! String,
//                            content: book.get("content") as! String,
//                            //                        created: <#T##Date?#>,
//                            //                        edited: <#T##Date?#>,
//                            price: book.get("price") as? Int,
//                            exchange: (book.get("exchange") as! Bool),
//                            sell: (book.get("sell") as! Bool),
//                            image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString()),
//                            index: ind))
//                        ind += 1
//                    }
//                }
//            }
//        }
//
//        func makebookmarklist() {
//            db.collection("users").document(userId).collection("bookmarks").getDocuments() { docus, err  in
//
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    guard let docus = docus?.documents else {
//                        print("books is nil")
//                        return
//                    }
//                    for docu in docus {
//                        self.bookmarkarray.append(docu.get("bookid") as! String)
//                    }
//                }
//            }
//        }
//
//    }
//}
