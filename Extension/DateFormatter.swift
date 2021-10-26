//
//  DateFormateer.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import Foundation

extension DateFormatter: ObservableObject {
    static let ContentDateFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .none
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
}
