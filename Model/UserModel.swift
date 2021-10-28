//
//  UserModel.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/24.
//

import Foundation
import SwiftUI
import CoreLocation


struct UserModel: Hashable, Codable, Identifiable{
    var id: Int                     // 고유 코드
    var name: String                // 작성자
    var createdDate: Date           // 작성일 Date
    var email: String               // 이메일
    private var imageName: String   // 이미지
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
