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
    let position: BubblePosition
    let color: Color
    let content: () -> Content
    
    init (position: BubblePosition, color: Color, @ViewBuilder content: @escaping () -> Content) {
        self.position = position
        self.color = color
        self.content = content
    }
    
    var body: some View {
        
        VStack {
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
            
            Text(Date(), style: .time)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(position == .left ? .trailing : .leading, 250)
        }
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble(position: .right, color: .green) {
            Text("hilwfweijflweijflweijffwefwifjlweifjwe")
        }
    }
}
