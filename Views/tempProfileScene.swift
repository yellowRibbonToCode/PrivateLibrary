//
//  tempProfileScene.swift
//  동네북
//
//  Created by 강희영 on 2021/11/17.
//

import SwiftUI

struct tempProfileScene: View {
    var body: some View {
        NavigationView{
            VStack {
                ZStack {
                    CircleImageView(image: UIImage(systemName: "person")!, width: 160 , height: 160)
                    Circle()
                        .stroke(Color.mainBlue, lineWidth: 1)
                        .frame(width: 170, height: 170)
                }
                Text("hekang")
                    .foregroundColor(.mainBlue)
                    .fontWeight(.bold)
                    .font(Font.system(size: 21))
                Text("hekang@hekang.com")
                    .fontWeight(.light)
                    .font(Font.system(size: 14))
                //                .tint(Color.red)
                    .tint(Color(red: 148/255, green: 148/255, blue: 148/255))
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .frame(width: 10, height: 15)
                    Text("동작구 사당동")
                        .font(Font.custom("S-CoreDream-5Medium", size: 16))
                }
                .foregroundColor(.mainBlue)
                Divider()
                    .padding()
                HStack(spacing: 0){
                    Spacer()
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width:23, height:23)
                        .foregroundColor(.mainBlue)
                    Spacer()
                    Spacer()
                    Image(systemName: "bookmark")
                        .resizable()
                        .frame(width:15, height:23)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.bottom, 15)
                HStack (spacing: 0) {
                    Rectangle()
                        .fill(Color.mainBlue)
                        .frame(height:1.5)
                        .padding(.leading)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height:0.3)
                        .padding(.trailing)
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("My")
                        .font(.title)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width:17, height:17)
                        .foregroundColor(.mainBlue)
                }
                
            }
        }
        
        
    }
}

struct tempProfileScene_Previews: PreviewProvider {
    static var previews: some View {
        tempProfileScene()
    }
}
