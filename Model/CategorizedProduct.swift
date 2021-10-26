//
//  CategorizedProduct.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/21.
//

import Foundation

struct CategorizedProduct: Identifiable, Hashable {
   let id = UUID()
   let header: String
   let footer: String?
   let list: [AppleProduct]
}

extension CategorizedProduct {
   static var sampleList: [CategorizedProduct] {
      return [
         CategorizedProduct(header: "iPhone",
                            footer: "Lorem Ipsum",
                            list: AppleProduct.sampleList.filter { $0.category == "iPhone" }),
         CategorizedProduct(header: "iPad",
                            footer: nil,
                            list: AppleProduct.sampleList.filter { $0.category == "iPad" }),
         CategorizedProduct(header: "Mac",
                            footer: nil,
                            list: AppleProduct.sampleList.filter { $0.category == "Mac" }),
         CategorizedProduct(header: "Apple Watch",
                            footer: nil,
                            list: AppleProduct.sampleList.filter { $0.category == "Apple Watch" })
      ]
   }
}
