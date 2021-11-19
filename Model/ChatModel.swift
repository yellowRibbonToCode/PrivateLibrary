//
//  ChatModel.swift
//  playGround
//
//  Created by 김진범 on 2021/11/11.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

// BubblePosition.swift
enum BubblePosition{
    case left
    case right
}

struct Message: Codable, Identifiable, Hashable {
    @DocumentID var id : String?
    var sendTime: Date
    var sender : String
    var msg : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case sendTime
        case sender
        case msg
    }
}

//chatBubble.swift
struct ChatBubble<Content>: View where Content:View {
    let time: Date
    let position: BubblePosition
    let color: Color
    let content: () -> Content
    
    init (time: Date, position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.time = time
        self.position = position
        self.color = color
        self.content = content
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            if self.position == .right {
                Spacer()
                Text(time, style: .time)
                    .font(Font.custom("S-CoreDream-4Regular", size: 8))
                    .foregroundColor(.mainBlue)
            }
            content()
                .font(Font.custom("S-CoreDream-4Regular", size: 13))
//                .frame(height: 36)
                .padding(.vertical, 10)
                .padding(.leading, 19)
                .padding(.trailing, 19)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .foregroundColor(color == .white ? .mainBlue : .white)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.mainBlue, lineWidth: 1)
                )
            if self.position == .left {
                Text(time, style: .time)
                    .font(Font.custom("S-CoreDream-4Regular", size: 8))
                    .foregroundColor(.mainBlue)
                Spacer()
            }
        }
        .padding(position == .left ? .leading : .trailing, 16)
        .padding(position == .right ? .leading : .trailing, 60)
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(time: Date(), position: .right, color: .mainBlue) {
            Text("hilwfweijfwifjlweifjwe")
        }
    }
}
