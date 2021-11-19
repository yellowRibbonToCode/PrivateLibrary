//
//  ProfileImageRow.swift
//  동네북
//
//  Created by sushin on 2021/11/19.
//

import SwiftUI
import UIKit
import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct ProfileImageRow: View {
    var libModel: ViewModel
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 10){
            ZStack(alignment: .topTrailing ){
                if let image = libModel.image {
                    image
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width / 2.3 , height:UIScreen.main.bounds.width / 2.3)
                        .cornerRadius(19)
                        .shadow(color: Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.1), radius: 6, x: 0, y: 3)
                }
                
                
            }
            HStack {
                if libModel.bookname.count > 15 {
                    Text(libModel.bookname.prefix(14) + "…")
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
                else {
                    Text(libModel.bookname)
                        .font(Font.custom("S-CoreDream-6Bold", size: 15))
                        .foregroundColor(.mainBlue)
                    +
                    Text(" ")
                    +
                    Text(libModel.title)
                    
                        .font(Font.custom("S-CoreDream-3Light", size: 15))
                        .foregroundColor(.black)
                }
            }
            .multilineTextAlignment(.leading)
            .lineLimit(2)
            .frame(height: 45, alignment: .topLeading)
            .truncationMode(.tail)
        }
    }
    
}
