//
//  ChatingView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ChatView: View {
//    @EnvironmentObject var backend: Backend
    let documentId: String
    let whoami: String
    @ObservedObject var messages = Messages()
    @State var msg: String = ""
    
    class Messages: ObservableObject {
        @Published var messages: [Message] = []
        
        func loadMessages(/*_ backend: Backend, */_ documentId: String) {
            Firestore.firestore().collection("chatings").document(documentId).collection("messages").order(by: "sendTime").addSnapshotListener { snap, err in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                
                guard let data = snap else {return}
                
//                data.documents.forEach { doc in
//                    self.messages.append(try! doc.data(as: Message.self)!)
//                }
                
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
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(messages.messages) { msg in
                            ChatBubble(position: msg.sender == whoami ? .right : .left,
                                       color: msg.sender == whoami ? .green : .blue) {
                                Text(msg.msg)
                            }
                        }
                    }
                }
                .onAppear {
                    print(documentId)
                    messages.loadMessages(documentId)
                    print(messages.messages)
                    // or when class init
                }
                .onChange(of: messages.messages) { newValue in
                    print(newValue)
                    proxy.scrollTo(messages.messages.last!.id , anchor: .bottom)
                }
            }.padding(.top)
            HStack(spacing: 15) {
                TextField("Enter Message", text: $msg)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                    
                if self.msg != "" {
                    Button(action: {
                        let msg = Message(sendTime: Date(), sender: whoami, msg: msg)
                        let _ = try! Firestore.firestore().collection("chatings/\(documentId)/messages").addDocument(from: msg) { err in
                            
                            if err != nil {
                                print(err!.localizedDescription)
                                return
                            }
                            self.msg = ""
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                            .frame(width: 45, height: 45)
//                            .background(Color("Color"))
                            .clipShape(Circle())
                    })
                }
            }.padding()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(documentId: "TE3j5N5HtGfprS4nTqe2", whoami: "hi")
    }
}
