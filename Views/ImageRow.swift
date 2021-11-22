//
//  ImageRow.swift
//  동네북
//
//  Created by sushin on 2021/11/22.
//

import SwiftUI


struct ImageRow: View {
    var libModel: ViewModel
    var showBookmark: Bool = true
    
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
                if showBookmark{
                    BookMarkButton(bookuid: libModel.id)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                }
                else
                {
                    EmptyView()
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


//
//struct ImageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageRow()
//    }
//}
