//
//  ChatRow.swift
//  동네북
//
//  Created by 김진범 on 2021/11/16.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct ChatRow: View {
    let roomId: String
    var partner = Partner()
    
    @State var profile: UIImage = UIImage(imageLiteralResourceName: "user-g")
    @State var name: String = "??"
    @State var lastMsg: String = " "
    
    private let users = Firestore.firestore().collection("users")
    private let storageRef = Storage.storage().reference()

    class Partner: ObservableObject {
//        @Published var id: String = "??"// 나중엔 배열로 받아서 프로필사진 여러개 받아서 띄우기
        
        func loadParticipants(_ roomId: String, completion: @escaping (Bool, String) -> Void) {
            Firestore.firestore().collection("chatings").document(roomId).getDocument { data, err in
                if let data = data?.get("partcipants") as? [String] {
                    DispatchQueue.main.async {
                        if data[0] == Auth.auth().currentUser!.uid {
                            completion(true, data[1])
                        } else {
                            completion(true, data[0])
                        }
                    }
                    return
                }
                print(err!)
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(uiImage: profile)
                .resizable()
                .frame(width: 68, height: 68)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(name)
                    .font(Font.custom("S-CoreDream-5Medium", size: 15))
                    .foregroundColor(.mainBlue)
                    .frame(height: 18, alignment: .leading)
                Text(lastMsg)
                    .font(Font.custom("S-CoreDream-2ExtraLight", size: 15))
                    .foregroundColor(Color(red: 173/255, green: 173/255, blue: 173/255))
                    .frame(height: 18, alignment: .leading)
            }
            .padding(.leading, 25)
            .padding(.trailing, 51)
            
            Spacer()
        }
        .padding(.leading, 27.0)
        .padding(.vertical, 9)
        .onAppear {
            partner.loadParticipants(roomId) { (success, id) in
                if success {
                    loadName(id)
                    loadProfile(id)
                    loadLastMsg()
                }
            }
        }
    }
    
    fileprivate func loadProfile(_ id: String) {
        let profileImageRef = storageRef.child("images/user_profile/\(id)")
        profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
            if let error = err {
                print(error)
                self.profile = UIImage(imageLiteralResourceName: "user-g")
            } else {
                self.profile = UIImage(data: data!)!
                print("loaded profile")
            }
        }
    }
    fileprivate func loadName(_ id: String) {
        let userInfo = users.document(id)
        userInfo.getDocument { (document, err) in
            if let document = document?.get("name") {
                self.name = document as! String
                print("loaded name")
            }
        }
    }
    fileprivate func loadLastMsg() {
        let msg = Firestore.firestore().collection("chatings").document(roomId).collection("messages").order(by: "sendTime").limit(toLast: 1)
        msg.getDocuments { data, err in
            if let document = data?.documents.last?.get("msg") {
                self.lastMsg = document as! String
                print("loaded msg")
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(roomId: "TE3j5N5HtGfprS4nTqe2")
    }
}
