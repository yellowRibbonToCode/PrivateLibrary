//
//  NewSushinForm.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import SwiftUI
// bookname author title content
// price exchange sell

struct NewSushinForm: View {
    
    @State var bookname: String = ""         // 책 제목
    @State var author: String = ""         // 책 저자
    @State var title: String = ""        // 한줄 요약
    @State var content: String = ""       // 게시글 내용
    @State var price: Int = 0                 // 가격
    @State var exchange: Bool = false          // 교환 가능 여부
    @State var sell: Bool = false            // 판매 가능 여부

    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var sushinListViewModel: SushinListViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 30) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Bookname")
                    .foregroundColor(.gray)
                TextField("Enter the bookname", text: $bookname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Author")
                    .foregroundColor(.gray)
                TextField("Enter the author", text: $author)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Title")
                    .foregroundColor(.gray)
                TextField("Enter the title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Content")
                    .foregroundColor(.gray)
                TextField("Enter the content", text: $content)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 10) {
                Text("Price")
                    .foregroundColor(.gray)
                TextField("Enter the price", value: $price, formatter: NumberFormatter()) //            .string(from: NSNumber(value:price))!
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack{
                Button(action: {
                    exchange = exchange ? false : true
                    
                }) {
                    HStack(alignment: .top, spacing: 10) {
                        
                        Image(systemName: self.exchange ? "checkmark.square" : "square")
                        Text("Exchange")
                    }
                }
                Button(action: {
                    sell = sell ? false : true
                    
                }) {
                    HStack(alignment: .top, spacing: 10) {
                        
                        Image(systemName: self.sell ? "checkmark.square" : "square")
                        Text("Sell")
                    }
                }
                
            }
            .foregroundColor(.gray)

            Button(action: addSushin) {
                Text("Add New Book")
                    .foregroundColor(.blue)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 80, leading: 40, bottom: 0, trailing: 40))
    }
    
    private func addSushin() {
        // 1
        let sushin = Sushin(bookname: bookname, author: author, title: title, content: content, price: price, exchange: exchange, sell: sell)
        // 2
        sushinListViewModel.add(sushin)
        // 3
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewSushinForm_Previews: PreviewProvider {
    static var previews: some View {
        NewSushinForm(sushinListViewModel: SushinListViewModel())
    }
}
