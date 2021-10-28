//
//  TestView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/26.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            HStack {
                Text("Best book")
                    .fontWeight(.heavy)
                    .padding(.leading, 30)
                    .font(.title)
                Spacer()
            }
        
            NavigationView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 30.0) {
                        ForEach(ModelData().library) { libModel in
                            NavigationLink(destination: DetailView(libModel: libModel)) {
                                GeometryReader { geometry in
                                    ImageRow(libModel: libModel)
                                        .frame(width: 200)
                                        .rotation3DEffect(Angle(degrees: Double(geometry.frame(in: .global).minX - 30) / -40), axis: (x: 0, y: 10.0, z: 0))
                                }
                                .frame(width: 200)
                            }
                        }
                    }
//                    .padding(.leading, 0)
                    .padding(.top, -30)
//                    .padding(.bottom, 70)
//                    .padding(.trailing , 60)
                    Spacer()
                }
            }
        }
        }
    }


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
