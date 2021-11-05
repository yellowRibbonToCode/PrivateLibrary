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
                VStack{
                    Spacer()
                    ZStack {
                        Rectangle()
                            .frame(width: 170, height: 70)
                            .foregroundColor(.white)
                            .opacity(0.7)

                        VStack {
                            Text(libModel.title)
                                .font(.system(size: 17))
                                .frame(width: 170, height: 50)
                                .padding([.leading, .trailing])
                                .lineLimit(2)
                            Spacer()
                            HStack {
                                Image(systemName: "bookmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 2)


                                Text("100")
                                    .font(.system(size: 13))
                                    .padding(.leading, -5)
                                    .padding(.bottom, 2)
                                    Spacer()
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .padding(.bottom, 3)
                                    .padding(.trailing, -5)
                                Text(libModel.name)
                                    .font(.system(size: 13))
//                                    .frame(width: 170, height: 20, alignment: .trailing)
                                    .padding(.trailing, 5)
                                    .padding(.bottom, 3)
                            }
                            .frame(width: 170, height: 25)
                        }
                    }
                    .frame(width: 170, height: 70)
                }
            }
            .cornerRadius(7)
        }
        .frame(width: 170, height: 200)
        .padding(EdgeInsets(top: 0, leading: 40, bottom: 20, trailing: 40))
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 10, y: 10)
        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }

}


struct ImageRow_Previews: PreviewProvider {
    static var previews: some View {
        ImageRow(libModel: ViewModel(id: "asdfasdf",
                                     useruid: "user_uid" ,
                                     name: "hekang",
                                     email: "hekang@hekang.com",
                                     bookname: "전문가를 위한 파이썬",
                                     author: "OREILLY",
                                     title: "이걸 읽으면 전문가가 될 수 있을까",
                                     content: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus, cras ante etiam sit conubia elit tempus accumsan libero, mattis per erat habitasse cubilia ligula penatibus curae. Sagittis lorem augue arcu blandit libero molestie non ullamcorper, finibus imperdiet iaculis ad quam per luctus neque, ligula curae mauris parturient diam auctor eleifend laoreet ridiculus, hendrerit adipiscing sociosqu pretium nec velit aliquam. Inceptos egestas maecenas imperdiet eget id donec nisl curae congue, massa tortor vivamus ridiculus integer porta ultrices venenatis aliquet, curabitur et posuere blandit magnis dictum auctor lacinia, eleifend dolor in ornare vulputate ipsum morbi felis. Faucibus cursus malesuada orci ultrices diam nisl taciti torquent, tempor eros suspendisse euismod condimentum dis velit mi tristique, a quis etiam dignissim dictum porttitor lobortis ad fermentum, sapien consectetur dui dolor purus elit pharetra. Interdum mattis sapien ac orci vestibulum vulputate laoreet proin hac, maecenas mollis ridiculus morbi praesent cubilia vitae ligula vel, sem semper volutpat curae mauris justo nisl luctus, non eros primis ultrices nascetur erat varius integer.",
                                     price: 35000,
                                     exchange: false,
                                     sell: false,
                                     image: Image("rainbowlake")))
        //        .previewLayout(.fixed(width: 300, height: 300))
    }
}
