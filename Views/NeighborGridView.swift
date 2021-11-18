//
//  NeighborGridView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/12.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Alamofire

class NeighborViewModel: ObservableObject {
    private let userid = Auth.auth().currentUser!.uid
    
    private var userLatitude = ""
    private var userLongitude = ""
    private var range = UserDefaults.standard.double(forKey: "range")
    
    @Published var bookmarkarray: [String] = []

    
    func getUserLocation() {
        db.collection("users").document(userid).getDocument { [self] user, err in
            if let user = user {
                self.userLatitude = user.get("latitude") as? String ?? ""
                self.userLongitude = user.get("longitude") as? String ?? ""
            } else {
                if let err = err {
                    print("Error getting documents: \(err)")
                }
            }
        }
    }
    
    func makeNeighborList(completionHandler: @escaping (String) -> Void) {
        getUserLocation()
        db = Firestore.firestore()
        self.range = UserDefaults.standard.double(forKey: "range")
        if self.range == 0 {
            self.range = 5.0
        }
        let _ = db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    db.collection("users").document(document.documentID).getDocument { userData, err in
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else if let userData = userData {
                            let tempLatitude = userData.get("latitude") as? String ?? ""
                            let tempLongitude = userData.get("longitude") as? String ?? ""
                            let distance = getDistance(latitude1: self.userLatitude, longitude1: self.userLongitude, latitude2: tempLatitude, longitude2: tempLongitude)
                            if (distance < self.range && distance > 0)
                            {
                                completionHandler(document.documentID)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    func makeNeighborBookList(completionHandler: @escaping (ViewModel) -> Void) {
        //        self.bookModels = [ViewModel]()
        self.makeNeighborList() {
            uid in
            print(uid)
            db.collection("libData").whereField("userid", isEqualTo: uid).getDocuments() {
                (books, err) in
                if let err = err{
                    print("Error getting documents: \(err)")
                }
                else {
                    guard let books = books?.documents else { return }
                    
                    for book in books {
                        func getImage(bookuid : String) {
                            Storage.storage().reference().child("images/books/\(bookuid)").getData(maxSize: 100 * 200 * 200) {
                                (imageData, err) in
                                if let _ = err as NSError? {
                                    let randInt = Int.random(in: 0...10)
                                    completionHandler(ViewModel(id: bookuid, useruid: book.get("userid") as! String ,
                                                                name: book.get("username") as! String,
                                                                email: book.get("useremail") as! String,
                                                                bookname: book.get("bookname") as! String,
                                                                author: book.get("author") as! String,
                                                                title: book.get("title") as! String,
                                                                content: book.get("content") as! String,
                                                                created: (book.get("created") as! Timestamp).dateValue(),
                                                                edited: (book.get("edited") as! Timestamp).dateValue(),
                                                                price: book.get("price") as? Int,
                                                                exchange: book.get("exchange") as! Bool,
                                                                sell: book.get("sell") as! Bool,
                                                                image: Image(RandBookImage(rawValue: randInt)!.toString())))
                                }
                            }
                        }
                        getImage(bookuid: book.documentID)
                    }
                }
            }
        }
    }
    
    func makebookmarklist() {
        db.collection("users").document(userid).collection("bookmarks").getDocuments() { docus, err  in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let docus = docus?.documents else {
                    print("books is nil")
                    return
                }
                for docu in docus {
                    self.bookmarkarray.append(docu.get("bookid") as! String)
                }
            }
        }
    }
}


struct NeighborGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var searchNeighborViewModel = NeighborViewModel()
    @State var neighborBookList = [ViewModel]()
    var body: some View {
        VStack{
            if !neighborBookList.isEmpty {
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns) {
                        ForEach ( neighborBookList.sorted { $0.created!.compare($1.created!) == .orderedDescending} ) {
                            Model in
                            NavigationLink(destination: NeighborDetailView(libModel: Model, books: searchNeighborViewModel)) {
                                NeighborImageRow(libModel: Model, books: searchNeighborViewModel)
                            }
                            .foregroundColor(.black)
                        }
                        .padding([.leading, .trailing], 10)
                    }
                }
            }
            else{
                VStack{
                    
                    Text("우리 동네에는 책이 없네요 ;(")
                        .font(Font.custom("S-CoreDream-6Bold", size: 18))
                        .foregroundColor(.mainBlue)
                }
            }}
        .onAppear(perform: {
            db = Firestore.firestore()
            neighborBookList = []
            searchNeighborViewModel.makeNeighborBookList(){
                Book in
                neighborBookList.append(Book)
            }
            searchNeighborViewModel.makebookmarklist()
        })
        .padding()
    }
}

struct NeighborGridView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborGridView()
    }
}
