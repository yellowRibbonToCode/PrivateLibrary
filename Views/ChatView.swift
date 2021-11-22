//
//  ChatingView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore

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
    let db = Firestore.firestore()
    
    init(_ documentId: String) {
        self.documentId = documentId
        self.messages = Messages(documentId: documentId)
    }
    
    class Messages: ObservableObject {
        @Published var messages: [Message] = []
        @Published var partner: String = "??"
        let db = Firestore.firestore()

        init (documentId: String) {
            loadMessages(documentId)
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
                        Firestore.firestore().collection("users").document(tmp[1]).getDocument { snap, err in
                            if let name = snap?.get("name") {
                                self.partner = name as! String
                            }
                        }
                    } else {
                        Firestore.firestore().collection("users").document(tmp[0]).getDocument { snap, err in
                            if let name = snap?.get("name") {
                                self.partner = name as! String
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
                    proxy.scrollTo(messages.messages.last!.id, anchor: .bottom)
                }
                .onAppear {
                    proxy.scrollTo(messages.messages.last!.id , anchor: .bottom)
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
        .onAppear {
            messages.loadPartnerName(documentId)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }
    
    var btnBack : some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            HStack(spacing: 0) {
                Image("chevron-left-p")
                Image("user-g")
                    .resizable()
                    .frame(width: 37, height: 37)
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
