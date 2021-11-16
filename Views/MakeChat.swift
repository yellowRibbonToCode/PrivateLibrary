//
//  MakeChat.swift
//  neighborbook
//
//  Created by 김진범 on 2021/11/15.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MakeChat: View {
    let other: String
    let me: String = Auth.auth().currentUser!.uid
    @ObservedObject var documentId = ChatRoom()


    var body: some View {
        if documentId.id == "" {
            Text("기다려")
                .onAppear {
                    documentId.checkPresence(other, me)
                }
        } else {
            ChatView(documentId: documentId.id)
        }
        // 참가자로 검색해서 documentId가 나오면 그걸 chatView에 전해주면 되고 ok
        // 없으면 uuid로 만들어서 participants입력한 문서 firestore에 저장하고 ok
        // 해당 documentId 전달.
    }
    
    class ChatRoom:ObservableObject {
        @Published var id: String = ""
        
        func checkPresence(_ other: String, _ me: String) {
            Firestore.firestore().collection("chatings").whereField("participants", in: [[other, me], [me, other]]).limit(to: 1).getDocuments { data, _ in
                if let docu = data?.documents.last?.documentID {
                    self.id = docu
                }
                let ref = Firestore.firestore().collection("chatings").addDocument(data: ["participants": [other, me]])
                self.id = ref.documentID
            }
        }
    }
}

//struct MakeChat_Previews: PreviewProvider {
//    static var previews: some View {
//        MakeChat()
//    }
//}
