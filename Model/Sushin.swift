//
//  Sushin.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import Foundation
import FirebaseFirestoreSwift

struct Sushin: Identifiable, Codable {
    @DocumentID var id: String?     // 책 uid
    
    var bookname: String            // 책 제목
    var author: String          // 책 저자
    var title: String            // 한줄 요약
    var content: String             // 게시글 내용

    var created: Date?          // 작성일 Date
    var edited: Date?         // 수정일 Date
    
    var price: Int                  // 가격
    var exchange: Bool = false          // 교환 가능 여부
    var sell: Bool = false            // 판매 가능 여부
    
    var userId: String?            //useruid
}

#if DEBUG
let testData = (1...10).map { i in
    Sushin(bookname: "Bookname #\(i)", author: "Author #\(i)", title: "Title #\(i)", content: "Content #\(i)", created: Date(), edited: Date(), price: 12, exchange: false, sell: true)
}
#endif


// edited 적용안됨
