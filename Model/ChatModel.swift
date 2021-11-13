//
//  ChatModel.swift
//  playGround
//
//  Created by 김진범 on 2021/11/11.
//

import Foundation
import SwiftUI

// BubblePosition.swift
enum BubblePosition{
    case left
    case right
}

struct Message: Codable{
    var sendTime: Date
    var sender : String
    var text : String
    
    init(_ sendTime: Date, _ text: String, _ sender: String) {
        self.sendTime = sendTime
        self.text = text
        self.sender = sender
    }
}

extension Message:Hashable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return
            lhs.sender == rhs.sender &&
            lhs.text == rhs.text &&
            lhs.sendTime == rhs.sendTime
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(sendTime)
        hasher.combine(sender)
        hasher.combine(text)
    }
}

// ChatModel.swift
class ChatModel: ObservableObject, Decodable {
    var text = ""
    
    @Published var messages : [Message] = []
    @Published var id: [String] = []
    
    private enum CodingKeys: String, CodingKey {
        case messages
        case id = "participants"
    }

    init(_ messages: [Message], _ participants: [String]) {
        self.messages = messages
        self.id = participants
    }
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        messages = try values.decode([Message].self, forKey: .messages)
        id = try values.decode([String].self, forKey: .id)
    }
}

extension ChatModel: Hashable, Identifiable {
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        return
            lhs.messages == rhs.messages &&
            lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

//chatBubble.swift
struct ChatBubble<Content>: View where Content:View {
    let position: BubblePosition
    let color: Color
    let content: () -> Content
    
    init (position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.position = position
        self.color = color
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 0) {
            content()
                .padding(.all, 15)
                .foregroundColor(Color.white)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(
                    Image(systemName: "arrowtriangle.left.fill")
                        .foregroundColor(color)
                        .rotationEffect(Angle(degrees: position == .left ? -50 : -130))
                        .offset(x: position == .left ? -5 : 5),
                    alignment: position == .left ? .bottomLeading : .bottomTrailing)
            
        }
        .padding(position == .left ? .leading : .trailing, 15)
        .padding(position == .right ? .leading : .trailing, 60)
        .frame(width: UIScreen.main.bounds.width, alignment: position == .left ? .leading : .trailing)
    }
}

