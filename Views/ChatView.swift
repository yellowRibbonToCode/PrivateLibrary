//
//  ChatingView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/10.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var model: ChatModel
    let whoami: String
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(0..<model.messages.count) { index in
                            ChatBubble(position: model.messages[index].sender == whoami ? .right : .left,
                                       color: model.messages[index].sender == whoami ? .green : .blue) {
                                Text(model.messages[index].text)
                                    .id(index)
                            }
                        }
                    }
                }
                .onChange(of: model.messages) { newValue in
                    if newValue.count > 0 {
                        proxy.scrollTo(newValue.count - 1, anchor: .bottom)
                    }
                }
            }.padding(.top)
            HStack {
                TextEditor(text: $model.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(Color.gray, width: 4)
                    .autocapitalization(.none)
                    .keyboardType(.alphabet)
                    .frame(height: 50)
                
                Button("Send") {
                    if model.text != "" {
                        model.messages.append(Message(Date(), model.text, whoami))
                        // db에 update
                        model.text = ""
                    }
                }
            }.padding()
        }
    }
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(model: ChatModel(), whoami: "hi")
//    }
//}
