//
//  ChatList.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/11.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct ChatList: View {
    @ObservedObject var chatRooms = ChatRooms()

    class ChatRooms: ObservableObject {
        @Published var rooms: [String] = []
        
        init() {
            loadChatRooms()
        }
        
        func loadChatRooms() {
            print("loadChatRoomgs")
            Firestore.firestore().collection("chatings").whereField("participants", arrayContains: Auth.auth().currentUser!.uid).addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                self.rooms = documents.map { $0.documentID }
            }
        }
    }
    
    var body: some View {
//        NavigationView {
            ScrollView {
                Divider()
                LazyVStack(spacing: 0) {
                    ForEach(chatRooms.rooms, id:\.self) { room in
                        NavigationLink(destination: ChatView(documentId: room)) {
                                ChatRow(roomId: room)
                        }
                    }
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Chat")
                            .font(.system(size: 34, weight: .bold))
                    }
                }
            }
//        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
