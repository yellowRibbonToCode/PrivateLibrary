//
//  Icon.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI

struct Icon: View {
    var body: some View {
        ZStack (alignment: .center){
            Image(systemName: "book.closed.fill")
                .resizable()
                .frame(width: 200.0, height: 200)
                .foregroundColor(.mainBrown)
            VStack (alignment: .leading){
//                Text("Read")
////                Text("wRite")
////                    .padding([.leading], -25)
//                Text("Record")
//                Text("Resell")
                Text("""
                    읽고
                    기록하고
                    팔고
                    """)
                    .multilineTextAlignment(.trailing)
            }
            .foregroundColor(.white)
//            .fontWeight(.bold)
            .font(.largeTitle)
            .padding(.leading, 40)
            .padding(.bottom, 30)
        }
    }
}
//읽고 기록하고 팔고


struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon()
    }
}
