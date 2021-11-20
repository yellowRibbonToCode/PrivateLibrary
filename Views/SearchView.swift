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
    @ObservedObject var books: TestBookmarkView.BookLists

    @FocusState private var nameIsFocused: Bool
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
                    .disableAutocorrection(true)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6))
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 8)
                                Button(action: {
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(Color(red: 0.235, green: 0.235, blue: 0.263, opacity: 0.6))
                                        .padding(.trailing, 8)
                                        .onTapGesture {
                                            self.txt = ""
                                            nameIsFocused = false
                                        }
                                }
                        }
                    )
                    .padding(.horizontal, 10)
                    .focused($nameIsFocused)
            }
            .padding(.bottom, 12)
            if self.txt != ""{
                if  self.data.filter({$0.bookname.lowercased().contains(self.txt.lowercased())}).count == 0{
                    Text("No Results Found").foregroundColor(Color.black.opacity(0.5)).padding()
                }
                else{
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns) {
                            ForEach (self.data.filter{$0.bookname.lowercased().contains(self.txt.lowercased())}) { book in
                                NavigationLink(destination: SearchDetailView(libModel: book, books: self.books)) {
                                TestBookmarkViewImageRow(libModel: book, books: self.books)
                                }
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
    @ObservedObject var books = TestBookmarkView.BookLists()
    
    @State var text: String = ""
    @ObservedObject var data = getFiterData()
    
    var body: some View {
//        NavigationView{
            VStack {
                SearchBar(txt: $text, data: self.$data.datas, books: books)
                Spacer(minLength: 20)
            }
            .navigationBarTitle("",  displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
//        }

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
                            image: Image(RandBookImage(rawValue: Int.random(in: 0...13))!.toString()),
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
            for book in snap!.documents{
                func getImage(bookuid : String) {
                    Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                        (imageData, err) in
                        if let _ = err as NSError? {
                            let randInt = Int.random(in: 0...13)
                            let bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                            self.datas.append(ViewModel(
                                id: book.documentID,
                                useruid: book.get("userid") as! String,
                                name: book.get("username") as! String,
                                email: book.get("useremail") as! String,
                                bookname: book.get("bookname") as! String,
                                author: book.get("author") as! String,
                                title: book.get("title") as! String,
                                content: book.get("content") as! String,
                                created: (book.get("created") as! Timestamp).dateValue(),
                                edited: (book.get("edited") as! Timestamp).dateValue(),
                                price: book.get("price") as? Int,
                                exchange: (book.get("exchange") as! Bool),
                                sell: (book.get("sell") as! Bool),
                                image: bookImage,
                                index: ind))
                            ind += 1
                        }
                        else {
                            let randInt = Int.random(in: 0...13)
                            var bookImage = Image(RandBookImage(rawValue: randInt)!.toString())
                            if let imageData = imageData {
                                bookImage = Image(uiImage: UIImage(data: imageData)!)
                            }
                            self.datas.append(ViewModel(
                                id: book.documentID,
                                useruid: book.get("userid") as! String,
                                name: book.get("username") as! String,
                                email: book.get("useremail") as! String,
                                bookname: book.get("bookname") as! String,
                                author: book.get("author") as! String,
                                title: book.get("title") as! String,
                                content: book.get("content") as! String,
                                created: (book.get("created") as! Timestamp).dateValue(),
                                edited: (book.get("edited") as! Timestamp).dateValue(),
                                price: book.get("price") as? Int,
                                exchange: (book.get("exchange") as! Bool),
                                sell: (book.get("sell") as! Bool),
                                image: bookImage,
                                index: ind))
                            ind += 1
                        }
                    }
                }
                getImage(bookuid: book.documentID)
            }
        }
    }
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

