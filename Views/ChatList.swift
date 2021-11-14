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
//    @EnvironmentObject var backend: Backend
    @ObservedObject var chatRooms = ChatRooms()

    class ChatRooms: ObservableObject {
        @Published var rooms: [String] = []
        
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
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(chatRooms.rooms, id: \.self) { roomId in
                        NavigationLink(destination: ChatView(documentId: roomId, whoami: Auth.auth().currentUser!.uid)) {
                            HStack {
                                // 나중에 채팅방 row이런거 만들어서 뷰
                                Text("hi")
                            }
                        }
                    }
                }
                .onAppear {
                    chatRooms.loadChatRooms()
                }
                .navigationTitle("Chanting")
            }
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
