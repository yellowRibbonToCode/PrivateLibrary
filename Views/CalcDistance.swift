//
//  CalcDistance.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/11.
//

// 거리 구하는 함수.

import Foundation



// 경도, 위도, 경도, 위도 순
// longitude, latitude, longitude, latitude
func getDistance(latitude1: String, longitude1: String, latitude2: String, longitude2: String) -> Double
{
    guard let x1 = Double(longitude1) else { return -1 }
    guard let y1 = Double(latitude1) else { return -1 }
    guard let x2 = Double(longitude2) else { return -1 }
    guard let y2 = Double(latitude2) else { return -1 }

    let fx1 = floor(x1)
    let fx2 = floor(x2)
    let fy1 = floor(y1)
    let fy2 = floor(y2)
    let R = 6378.135 // km

    let xDo = fx1 - fx2
    let yDo = fy1 - fy2
    
    let xBun1 = floor((x1 - fx1) * 60)
    let xBun2 = floor((x2 - fx2) * 60)
    let xBun = xBun1 - xBun2
    let yBun1 = floor((y1 - fy1) * 60)
    let yBun2 = floor((y2 - fy2) * 60)
    let yBun = yBun1 - yBun2

    let xCho1 = floor(((((x1 - fx1) * 60) - xBun1) * 60) * 100)
    let xCho2 = floor(((((x2 - fx2) * 60) - xBun2) * 60) * 100)
    let xCho = (xCho1 - xCho2) / 100
    let yCho1 = floor(((((y1 - fy1) * 60) - yBun1) * 60) * 100)
    let yCho2 = floor(((((y2 - fy2) * 60) - yBun2) * 60) * 100)
    let yCho = (yCho1 - yCho2) / 100

    let C = cos((y1 + y2) / 2 * Double.pi / 180) * 2 * Double.pi * R / 360
    let D = 2 * 3.14 * R / 360

    let disY = (yDo * C) + (yBun * C / 60) + (yCho * C / 60 / 60)
    let disX = (xDo * D) + (xBun * D / 60) + (xCho * D / 60 / 60)
    let Distance = sqrt(pow(disX, 2) + pow(disY,2))
    
//    print(Distance)
    return Distance
}
