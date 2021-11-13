//
//  ChatList.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/11.
//

import SwiftUI
import Firebase

struct ChatList: View {
    @EnvironmentObject var backend: Backend
    @ObservedObject var chatRooms = ChatRooms()

    class ChatRooms: ObservableObject {
        @Published var rooms: [ChatModel] = []
        
        func loadChatRooms(_ backend: Backend) {
            print("loadChatRoomgs")
            backend.chatings.whereField("participants", arrayContains: backend.user!.uid).addSnapshotListener { snapshot, err in
                if let err = err {
                    print("Error getting chatings documents: \(err)")
                } else {
                    guard let rooms = snapshot?.documents else {
                        print("rooms is nil")
                        return
                    }
                    for room in rooms {
                        let result = Result {
                            try room.data(as: ChatModel.self)
                        }
                        switch result {
                        case .success(let chat):
                            if let chat = chat {
                                self.rooms.append(chat)
                                print("append something")
                            } else {
                                print("Documents does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding chat: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            LazyVStack {
                ForEach(chatRooms.rooms) { room in
                    NavigationLink(destination: ChatView(model: room, whoami: backend.user!.uid)) {
                        HStack {
                            // 나중에 채팅방 row이런거 만들어서 뷰
                            Text("hi")
                        }
                    }
                }
            }
            .onAppear {
                chatRooms.loadChatRooms(backend)
            }
            .navigationTitle("Chanting")
        }
    }
}

struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        ChatList()
    }
}
