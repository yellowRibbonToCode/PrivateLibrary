//
//  ViewModel.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/24.
//

import Foundation
import SwiftUI
import CoreLocation


struct ViewModel: Hashable, Codable, Identifiable{
    var id: Int                     // 고유 코드
    var bookName: String            // 책 제목
    var bookWriter: String          // 책 저자
    var name: String                // 작성자
    var email: String               // 이메일
    var abstract: String            // 한줄 요약
    var content: String             // 게시글 내용
    var isbn: Int                   // ISBN(Book id)

    var createdDate: Date           // 작성일 Date
    var editedDate: Date            // 수정일 Date
    private var imageName: String   // 이미지
    var transitDate: Date           // 거래 완료일 Date
    var price: Int                  // 가격
    var isChangable: Bool           // 교환 가능 여부
    var isTradable: Bool            // 판매 가능 여부
    var image: Image {
        Image(imageName)
    }
    
//    private var coordinates: Coordinates
//    var locationCoordinate: CLLocationCoordinate2D{
//        CLLocationCoordinate2D(latitude: coordinates.latitude
//                               , longitude: coordinates.longitude)
//    }
//
//    struct Coordinates: Hashable, Codable {
//        var latitude: Double
//        var longitude: Double
//    }
    
}
