//
//  ImageRow.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/26.
//

import SwiftUI

struct ImageRow: View {
    var libModel: ViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack{
                if let image = libModel.image {
                    image
                    .resizable()
                    .frame(width: 170, height: 200)
                    .clipped()
                    
                }
                Text(libModel.title)
                    .foregroundColor(.black)
                    .fontWeight(.heavy)
                    .font(.system(size: 24))
                    .offset(y: 150)
                    .frame(width: 170, height: 200)
            }
        }
        .frame(width: 250, height: 300)
        .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 40))
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }
    
}


struct ImageRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            ImageRow(libModel: )
            //                        ImageRow(libModel: ModelData().library[2])
            
        }
        //        .previewLayout(.fixed(width: 300, height: 300))
    }
}
