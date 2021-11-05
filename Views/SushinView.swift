//
//  SushinView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/05.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage


struct SushinView: View {
    var booksModel: ViewModel

        @State var showContent: Bool = false
        @State var viewState = CGSize.zero
        
        var body: some View {
            ZStack(alignment: .center) {
                backView.opacity(showContent ? 1 : 0)
                frontView.opacity(showContent ? 0 : 1)
            }
            .frame(width: 180, height: 270)
//            .background(Color.orange)
            .cornerRadius(20)
            .shadow(color: Color(.blue).opacity(0.3), radius: 5, x: 10, y: 10)
            .rotation3DEffect(.degrees(showContent ? 180.0 : 0.0), axis: (x: 0, y: -1, z: 0))
            .offset(x: viewState.width, y: viewState.height)
            .animation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0))
//            .onTapGesture {
//                withAnimation {
//                    showContent.toggle()
//                }
//            }
        }
        // text == nil ? (textIN = false) : (textIn = true)
        var frontView: some View {
            VStack(alignment: .center) {
                Spacer()
                ZStack{
                if let image = booksModel.image {
                    image
                        .resizable()
                        .frame(width: 180, height: 270)
                        .clipped()
                }
                Text(booksModel.bookname)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(20.0)
                Spacer()
            }
            }
        }

        var backView: some View {
            VStack {
                // 1
                Spacer()
                VStack {
                    Text(booksModel.bookname)
                    Text(booksModel.author)
                    Text(booksModel.title)
                    Text(booksModel.content)
                    Text(booksModel.name)
                }
                .foregroundColor(.white)
                .font(.body)
                .padding(20.0)
                .multilineTextAlignment(.center)
                .animation(.easeInOut)
                Spacer()
            }
            .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
        }
 
}
//
//struct SushinView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sushin = ViewModel( id: "id",  useruid: "useruid", name: "name", email: "email", bookname: "Bookname ", author: "Author ", title: "Title ", content: "Content", created: Date(), edited: Date(), price: 12, exchange: false, sell: true)
//                return SushinView(booksModel: sushin)
//     }
//}
