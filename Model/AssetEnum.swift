//
//  AssetEnum.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/04.
//

import Foundation

enum RandBookImage : Int {
    case charleyrivers = 0
    case chilkoottrail
    case chincoteague
    case hiddenlake
    case icybay
    case lakemcdonald
    case rainbowlake
    case silversalmoncreek
    case turtlerock
    case twinlake
    case umbagog
    
    func toString() -> String {
        switch self {
        case .charleyrivers:
            return "charleyrivers"
        case .chilkoottrail:
            return "chilkoottrail"
        case .chincoteague:
            return "chincoteague"
        case .hiddenlake:
            return "hiddenlake"
        case .icybay:
            return "icybay"
        case .lakemcdonald:
            return "lakemcdonald"
        case .rainbowlake:
            return "rainbowlake"
        case .silversalmoncreek:
            return "silversalmoncreek"
        case .turtlerock:
            return "turtlerock"
        case .twinlake:
            return "twinlake"
        case .umbagog:
            return "umbagog"
        }
    }
}
