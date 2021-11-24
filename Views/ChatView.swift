//
//  ChatingView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import simd

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode

    let documentId: String
    let whoami: String = Auth.auth().currentUser!.uid
    @ObservedObject var messages: Messages
    @State var msg: String = ""
    @State var showingActionSheet = false
    
    init(_ documentId: String) {
        print("newly generated\n\n")
        self.documentId = documentId
        self.messages = Messages(documentId: documentId)
   
    }
    
    class Messages: ObservableObject {
        @Published var messages: [Message] = []
        @Published var partner: String = "??"
        @Published var partnerImage: UIImage = UIImage(imageLiteralResourceName: "user-g")
        @Published var partnerId: String?
        let storageRef = Storage.storage().reference()
        
        init (documentId: String) {
            loadMessages(documentId)
            loadPartnerName(documentId)
            loadPartnerImage(documentId)
        }
        
        func loadMessages(_ documentId: String) {
            db.collection("chatings").document(documentId).collection("messages").order(by: "sendTime").addSnapshotListener { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                guard let data = snap else {return}
                
                data.documentChanges.forEach { doc in
                    if doc.type == .added {
                        let msg =  try! doc.document.data(as: Message.self)!
                        DispatchQueue.main.async {
                            self.messages.append(msg)
                        }
                    }
                }
            }
        }
        
        func loadPartnerName(_ documentId: String) {
            db.collection("chatings").document(documentId).getDocument { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                guard let data = snap else {return}
                
                if let tmp = (data.get("participants") as? [String]) {
                    if Auth.auth().currentUser!.uid == tmp[0] {
                        self.partnerId = tmp[1]
                        db.collection("users").document(tmp[1]).getDocument { snap, err in
                            if let name = snap?.get("name") {
                                self.partner = name as! String
                            }
                        }
                    } else {
                        self.partnerId = tmp[0]
                        db.collection("users").document(tmp[0]).getDocument { snap, err in
                            if let name = snap?.get("name") {
                                self.partner = name as! String
                            }
                        }
                    }
                }
            }
        }
        
        func loadPartnerImage(_ documentId: String) {
            db.collection("chatings").document(documentId).getDocument { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                guard let data = snap else {return}
                let storageRef = Storage.storage().reference()
                
                if let tmp = (data.get("participants") as? [String]) {
                    var part: String?
                    if Auth.auth().currentUser!.uid == tmp[0] {
                        part = tmp[1]
                    } else {
                        part = tmp[0]
                    }
                    let lastProfile = UserDefaults.standard.data(forKey: part!)

                    if lastProfile != nil {
                        self.partnerImage = UIImage(data: lastProfile!)!
                    }
                    
                    db.collection("users").document(part!).getDocument { snap, err in
                        let profileImageRef = storageRef.child("images/user_profile/\(part!)")
                        let lastUpdated = UserDefaults.standard.object(forKey: "\(part!)Updated") as? Date
                        
                        profileImageRef.getMetadata { metadata, err in
                            var updated : Date?
                            
                            if let data = metadata {
                                updated = data.updated
                            }
                            if lastUpdated != nil && updated != nil && lastUpdated! >= updated! {
                                self.partnerImage = UIImage(data: UserDefaults.standard.data(forKey: part!)!)!
                                return
                            }
                            profileImageRef.getData(maxSize: Int64(1 * 1024 * 1024)) { data, err in
                                if let error = err {
                                    print(error)
                                    self.partnerImage = UIImage(imageLiteralResourceName: "user-g")
                                    UserDefaults.standard.removeObject(forKey: part!)
                                    UserDefaults.standard.removeObject(forKey: "\(part!)Updated")
                                } else {
                                    self.partnerImage = UIImage(data: data!)!
                                    UserDefaults.standard.set(data, forKey: part!)
                                    UserDefaults.standard.set(updated, forKey: "\(part!)Updated")
                                    print("loaded profile")
                                }
                            }
                        }
                    }
            }
        }
    }
}

var body: some View {
    VStack(spacing: 0) {
        Divider()
            .padding(.top, 10)
        ScrollViewReader { proxy in
            ScrollView(.vertical) {
                LazyVStack {
                    Spacer()
                        .frame(height: 5)
                    ForEach(messages.messages) { msg in
                        ChatBubble(time: msg.sendTime, position: msg.sender == whoami ? .right : .left,
                                   color: msg.sender == whoami ? .mainBlue : .white) {
                            Text(msg.msg)
                        }
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) {_ in
                if let _ = messages.messages.last {
                    proxy.scrollTo(messages.messages.last!.id , anchor: .bottom)
                }
            }
            .onAppear {
                if let _ = messages.messages.last {
                    proxy.scrollTo(messages.messages.last!.id , anchor: .bottom)
                }
            }
            .onChange(of: messages.messages) { newValue in
                print(newValue)
                proxy.scrollTo(messages.messages.last!.id , anchor: .bottom)
            }
        }
        HStack(spacing: 9) {
            TextField("", text: $msg)
                .padding(.horizontal)
                .frame(height: 36)
                .background(Color.primary.opacity(0.06))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disableAutocorrection(true)
            
            Button(action: {
                if self.msg == "" {
                    return
                }
                let msg = Message(sendTime: Date(), sender: whoami, msg: msg)
                let _ = try! db.collection("chatings/\(documentId)/messages").addDocument(from: msg) { err in
                    if err != nil {
                        print(err!.localizedDescription)
                        return
                    }
                    self.msg = ""
                }
            }, label: {
                Image("arrow-right-circle")
                    .font(Font.system(size: 32, weight: .light))
                
            })
        }.padding(5)
    }
    .onTapGesture {
        UIApplication.shared.closeKeyboard()
    }
    .navigationBarBackButtonHidden(true)
    .toolbar {
        ToolbarItem (placement: .navigationBarLeading) {
            btnBack
        }
        ToolbarItem (placement: .navigationBarTrailing) {
            Button {
                showingActionSheet.toggle()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.mainBlue)
            }
        }
        
    }
    .confirmationDialog("", isPresented: $showingActionSheet) {
        Button("상대방 차단", role: .destructive) {
            if var arr = UserDefaults.standard.object(forKey: "blockuseruid") as? [String] {
                arr.append(messages.partnerId!)
                UserDefaults.standard.set(arr, forKey: "blockuseruid")
            } else {
                var arr = [String]()
                arr.append(messages.partnerId!)
                UserDefaults.standard.set(arr, forKey: "blockuseruid")
            }
            guard let partner = messages.partnerId else { return }
            
            let batch = db.batch()
            let userRef = db.collection("users").document(self.whoami)
            batch.updateData(["blockuseruid" : FieldValue.arrayUnion([partner])], forDocument: userRef)
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded")
                }
            }
            self.presentationMode.wrappedValue.dismiss()
        }
        Button("채팅방 나가기") {
            guard let partner = messages.partnerId else { return }

            let batch = db.batch()
            let chatRef = db.collection("chatings").document(self.documentId)
            batch.updateData(["participants" : partner], forDocument: chatRef)
            batch.commit() { err in
                if let err = err {
                    print("Error writing batch \(err)")
                } else {
                    print("Batch write succeeded")
                }
            }
            self.presentationMode.wrappedValue.dismiss()
        }
        Button("취소", role: .cancel) {}
    }
}

var btnBack : some View {
    Button {
        self.presentationMode.wrappedValue.dismiss()
    } label: {
        HStack(spacing: 0) {
            Image("chevron-left-p")
            Image(uiImage: messages.partnerImage)
                .resizable()
                .frame(width: 37, height: 37)
                .clipShape(Circle())
                .padding(.leading, 12)
                .foregroundColor(.gray)
            Text(messages.partner)
                .bold()
                .font(.system(size: 34))
                .padding(.leading, 12)
                .foregroundColor(.black)
        }
    }
}
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView("TE3j5N5HtGfprS4nTqe2")
    }
}
