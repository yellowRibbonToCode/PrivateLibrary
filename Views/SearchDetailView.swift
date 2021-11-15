//
//  SearchDetailView.swift
//  동네북
//
//  Created by SSB on 2021/11/13.
//

import SwiftUI

struct SearchDetailView : View {
    var libModel: ViewModel

    var body : some View{
        
        VStack{
            if let image = libModel.image {
                image
                .resizable()
                .aspectRatio(1.35, contentMode: .fill)
                .frame(width:UIScreen.main.bounds.width,height: 500)
                .offset(y: -200)
                .padding(.bottom, -200)
            }
            GeometryReader{geo in
                
                VStack(alignment: .leading){
                    
                   detailTop(libModel: libModel)
                   detailMiddle(libModel: libModel)
                   detailBottom(libModel: libModel)
                    
                }
                
            }.background(Color.white)
            .clipShape(Rounded())
            .padding(.top, -75)
            
        }
    }
}

struct detailTop : View {
    var libModel: ViewModel
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 10){
            
            
                Text(libModel.bookname).fontWeight(.heavy).font(.largeTitle)
                
            
            
        }.padding()
    }
}


struct detailMiddle : View {
    var libModel: ViewModel

    var body : some View{
        
        VStack(alignment: .leading, spacing: 15){
            

            Text(libModel.name).fontWeight(.heavy)
            
            Text(libModel.title).foregroundColor(.gray)
            
            
        }.padding(.horizontal,15)
    }
}

struct detailBottom : View {
    var libModel: ViewModel

    var body : some View{
        
        VStack(alignment: .leading, spacing: 10){
            
            Text("Content").fontWeight(.heavy)
            Text(libModel.content).foregroundColor(.gray)
            
            HStack(spacing: 8){
                
                Button(action: {
                    
                }) {
                    
                    Image(systemName: "bookmark").renderingMode(.original)
                }
                
                Button(action: {
                    
                }) {
                    
                    HStack(spacing: 6){
                        
                        Text("Go chat")
                        Image(systemName: "arrow.right").renderingMode(.original)
                        
                    }.foregroundColor(.white)
                    .padding()
                    
                }.background(Color.mainBlue)
                .cornerRadius(8)
                
            }.padding(.top, 6)
            
        }.padding()
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 40, height: 40))
        return Path(path.cgPath)
    }
}

//
//struct SearchDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchDetailView()
//    }
//}
