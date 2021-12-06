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
    var reportarr : [String] = []
    var blockArr : [String] = []
    @Published var userLatitude = ""
    private var userLongitude = ""
    var range = UserDefaults.standard.double(forKey: "range")
    
    @Published var bookmarkarray: [String] = []
    @Published var neighborList : [String] = []
    
    init() {
        makeNeighborList()
    }
    
    func getUserLocation() {
        print(self.range)
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
    
    func makeNeighborList() {
        neighborList = []
        self.range = UserDefaults.standard.double(forKey: "range")
        getUserLocation()
        print("range: " , self.range)
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
                            if (distance < self.range && distance >= 0)
                            {
                                self.neighborList.append(document.documentID)
                            }
                        }
                    }
                }
            }
        }
    }
}


struct NeighborGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    @ObservedObject var searchNeighborViewModel = NeighborViewModel()
    @State var neighborBookList = [ViewModel]()
    let useruid = Auth.auth().currentUser!.uid
    @ObservedObject var books = getBookList()
    @State var emptyBooks = true
    
    var body: some View {
        VStack{
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach ( books.bookList.sorted { $0.created!.compare($1.created!) == .orderedDescending} ) {
                        book in
                        if (searchNeighborViewModel.neighborList.contains(book.useruid) && book.reports!.count < 2 && !book.blocks!.contains(useruid)) {
                            NavigationLink(destination: DetailView(libModel: book)) {
                                ImageRow(libModel: book)
                            }
                            .onAppear {
                                emptyBooks = false
                            }
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
            .overlay {
                if emptyBooks {
                    VStack{
                        if searchNeighborViewModel.userLatitude != ""{
                            Text("우리 동네에는 책이 없네요 ;(")
                                .font(Font.custom("S-CoreDream-6Bold", size: 18))
                                .foregroundColor(.mainBlue)
                        }
                        else {
                            Text("주소 설정이 필요해요 :D")
                                .font(Font.custom("S-CoreDream-6Bold", size: 18))
                                .foregroundColor(.mainBlue)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct NeighborGridView_Previews: PreviewProvider {
    static var previews: some View {
        NeighborGridView()
    }
}
