//
//  tempProfileEditScene.swift
//  동네북
//
//  Created by 강희영 on 2021/11/17.
//

import SwiftUI

struct tempProfileEditScene: View {
    @State var username :String = ""
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            ZStack {
                Color.mainBlue
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    ZStack {
                        CircleImageView(image: UIImage(systemName: "person")!, width: 160 , height: 160)
                            .foregroundColor(.white)
                        Circle()
                            .foregroundColor(.white)
                            .opacity(0.76)
                            .frame(width: 160, height: 160)
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 170, height: 170)
                        Image(systemName: "camera")
                            .frame(width:31, height: 23)
                            .foregroundColor(.mainBlue)
                        
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainBlue, lineWidth: 1)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(width: 240, height: 35)
                        
                        TextField("이름", text: $username)
                            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
                            .background(.white)
                            .padding()
                            .frame(width: 240, height: 35)
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 28)
                    //                    Button {
                    //                        self 주소찾기
                    //                    } label: {
                    Text("주소 설정")
                        .foregroundColor(.white)
                        .font(Font.custom("S-CoreDream-5Medium", size: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 134, height: 36)
                        )
                    //                }
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width:18, height:12)
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "checkmark.square")
                            .resizable()
                            .frame(width:17, height:17)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
struct tempProfileEditScene_Previews: PreviewProvider {
    static var previews: some View {
        tempProfileEditScene()
    }
}
