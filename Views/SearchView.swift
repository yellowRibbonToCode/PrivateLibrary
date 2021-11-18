//
//  SearchView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/09.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct SearchBar: View {
    @Binding var txt: String
    @Binding var data : [ViewModel]
    @Binding var isEditing: Bool
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            HStack {
                Text("Search")
                    .font(.system(size: 34, weight: .bold))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
            }
            //            #7676801F
            HStack {
                TextField("Search", text: $txt)
                    .padding(7)
                    .padding(.horizontal, 25.0)
                    .background(Color(red: 0.463, green: 0.463, blue: 0.502, opacity: 0.12))
                    .foregroundColor(Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6))
                    .cornerRadius(8)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                            
                            if isEditing {
                                Button(action: {
                                    self.txt = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6))
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.txt = ""
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                }
            }
            if self.txt != ""{
                if  self.data.filter({$0.name.lowercased().contains(self.txt.lowercased())}).count == 0{
                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                }
                else{
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns) {
                            ForEach (self.data.filter{$0.name.lowercased().contains(self.txt.lowercased())}) { i in
                                SearchImageRow(libModel: i)
                                    .frame(width: 200, height: 200)
                                    .padding([.top], 5)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    }
                }
            }
            
        }
        
    }
}

struct SearchView: View {
    @ObservedObject var books = BookLists()
    
    @State var text: String = ""
    @State var isEditing: Bool = false
    @ObservedObject var data = getFiterData()
    
    var body: some View {
//        NavigationView{
            VStack {
                SearchBar(txt: $text, data: self.$data.datas, isEditing: $isEditing)
                Spacer(minLength: 20)
                if isEditing {
                    
                    EmptyView()
                }
                else {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Neighbor Books")
                                .font(.system(size: 26, weight: .bold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        }
                        HStack(spacing: 10) {
                            //                            SnapCarousel(bookModels: books.bookList).environmentObject(UIStateModel())
                            Color.white
                        }
                        .onAppear(perform: {
                            books.loadBooks()
                        })
                    }
                    Divider()
                    VStack(alignment: .leading) {
                        HStack {
                            Text("New Book")
                                .font(.system(size: 26, weight: .bold))
                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        }
                        HStack(spacing: 10) {
                            //                            SnapCarousel(bookModels: books.bookList).environmentObject(UIStateModel())
                            Color.white
                        }
                    }
                }
            }
            .navigationBarTitle("",  displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
//        }
    }
}

struct SearchImageRow: View {
    var libModel: ViewModel
    @State var show = false

    var body: some View {
        HStack(spacing: 20){
            VStack(alignment: .leading,spacing: 12){
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    if let image = libModel.image {
                        image
                            .resizable()
                            .frame(width: 170, height: 200)
                    }
                }
                
                Text(libModel.bookname).fontWeight(.heavy).foregroundColor(.mainBlue)
                
                HStack(spacing: 5){
                    
                    Image(systemName: "person")
                    Text(libModel.name).foregroundColor(.gray)
                }
            }
        }
        .sheet(isPresented: $show) {
//            SearchDetailView(libModel: libModel)
        }
        
    }
}


































extension SearchView {
    class BookLists: ObservableObject {
        @Published var bookList: [ViewModel] = []
        //    private var bookImage = UIImage(systemName: "book")
        //        private let userid = Auth.auth().currentUser!.uid
        private let db = Firestore.firestore()
        //        @State var index: Int = 0
        
        func loadBooks() {
            db.collection("libData").getDocuments() { books, err in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard let books = books?.documents else {
                        print("books is nil")
                        return
                    }
                    var ind: Int = 0
                    for book in books {
                        self.bookList.append(ViewModel(
                            id: book.documentID,
                            useruid: book.get("userid") as! String,
                            name: book.get("username") as! String,
                            email: book.get("useremail") as! String,
                            bookname: book.get("bookname") as! String,
                            author: book.get("author") as! String,
                            title: book.get("title") as! String,
                            content: book.get("content") as! String,
                            //                        created: <#T##Date?#>,
                            //                        edited: <#T##Date?#>,
                            price: book.get("price") as? Int,
                            exchange: (book.get("exchange") as! Bool),
                            sell: (book.get("sell") as! Bool),
                            image: Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString()),
                            index: ind))
                        ind += 1
                    }
                }
            }
        }
    }
}

class getFiterData : ObservableObject{
    
    @Published var datas = [ViewModel]()
    
    init() {
        let db = Firestore.firestore()
        db.collection("libData").getDocuments { (snap, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            var ind: Int = 0
            for i in snap!.documents{
                
                let id = i.documentID
                let useruid = i.get("userid") as! String
                let name = i.get("username") as! String
                let email = i.get("useremail") as! String
                let bookname = i.get("bookname") as! String
                let author = i.get("author") as! String
                let title = i.get("title") as! String
                let content = i.get("content") as! String
                let price = i.get("price") as? Int
                let exchange = (i.get("exchange") as! Bool)
                let sell = (i.get("sell") as! Bool)
                let image = Image(RandBookImage(rawValue: Int.random(in: 0...10))!.toString())
                let index = ind
                self.datas.append(ViewModel(
                    id: id,
                    useruid: useruid,
                    name: name,
                    email: email,
                    bookname: bookname,
                    author: author,
                    title: title,
                    content: content,
                    price: price,
                    exchange: exchange,
                    sell: sell,
                    image: image,
                    index: index
                ))
                ind += 1
            }
        }
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

