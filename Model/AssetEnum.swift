//
//  AssetEnum.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/04.
//

import Foundation

enum RandBookImage : Int {
    case dummy01 = 0
    case dummy02
    case dummy03
    case dummy04
    case dummy05
    case dummy06
    case dummy07
    case dummy08
    case dummy09
    case dummy10
    case dummy11
    case dummy12
    case dummy13
    case dummy14
    
    
    func toString() -> String {
        switch self {
        case .dummy01:
            return "dummy01"
        case .dummy02:
            return "dummy02"
        case .dummy03:
            return "dummy03"
        case .dummy04:
            return "dummy04"
        case .dummy05:
            return "dummy05"
        case .dummy06:
            return "dummy06"
        case .dummy07:
            return "dummy07"
        case .dummy08:
            return "dummy08"
        case .dummy09:
            return "dummy09"
        case .dummy10:
            return "dummy10"
        case .dummy11:
            return "dummy11"
        case .dummy12:
            return "dummy12"
        case .dummy13:
            return "dummy13"
        case .dummy14:
            return "dummy14"
            
        }
    }
}
