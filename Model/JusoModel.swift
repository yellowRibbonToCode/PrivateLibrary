//
//  JusoModel.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/09.
//

import Foundation
import SwiftUI

struct JusoResponse: Codable {
    var results: JusoResults!
}

struct JusoResults: Codable {
    var common: Common!
    var juso: [Juso]!
}

struct Common: Codable {
    var errorCode: String!
    var currentPage: String!
    var totalCount: String!
    var errorMessage: String!
}

struct Juso: Codable, Identifiable {
    var id = UUID()
    var roadAddr: String!
    var jibunAddr: String!
    
    private enum CodingKeys : String, CodingKey { case roadAddr, jibunAddr }
}

struct LocationHead: Codable {
    var documents : [LocationDocument]!
}

struct LocationDocument: Codable {
    var address : LocationAddress!
}

struct LocationAddress: Codable {
    var x: String!
    var y: String!
}
