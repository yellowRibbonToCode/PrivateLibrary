//
//  ViewModel.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/24.
//

import Foundation
import SwiftUI
import CoreLocation


struct ViewModel: Identifiable{
    var id: String                     // 고유 코드
    var name: String                // 작성자
    var email: String               // 이메일
    
    var bookname: String            // 책 제목
    var author: String          // 책 저자
    var title: String            // 한줄 요약
    var content: String             // 게시글 내용

    var created: Date           // 작성일 Date
    var edited: Date            // 수정일 Date

    var price: Int?                  // 가격
    var exchange: Bool           // 교환 가능 여부
    var sell: Bool            // 판매 가능 여부
    var image: Image?
    
}
