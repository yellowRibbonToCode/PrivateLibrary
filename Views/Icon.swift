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
<<<<<<< HEAD
=======

>>>>>>> main
                .foregroundColor(Color(hue: 0.377, saturation: 0.875, brightness: 0.4))
                
//                .aspectRatio(contentMode: .fit)
//                .clipShape(Circle().inset(by: CGFloat(-50)))
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .inset(by: CGFloat(-20))
                            .stroke(Color(hue: 0.377, saturation: 0.875, brightness: 0.4), lineWidth: 20))
//                .shadow(radius: 15)
<<<<<<< HEAD
=======

>>>>>>> main
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
<<<<<<< HEAD
            
=======

>>>>>>> main
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
