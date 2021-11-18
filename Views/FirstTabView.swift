//
//  FirstTabView.swift
//  동네북
//
//  Created by 강희영 on 2021/11/18.
//

import SwiftUI
import UIKit

struct FirstTabView: View {
    var Views = ["Books", "NeighborBooks"]
    @State var selectedView = 0
    @State var naviTitle = "Book"
    @State var setDistance = 0
    @State var showDistance = false
    var body: some View {
        
            VStack{
                if selectedView == 0{
                    TestBookmarkView()
                } else {
                    NeighborGridView()
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text(naviTitle)
                            .font(.system(size: 44, weight: .bold))
                        Menu("⌵") {
                            Button("Book", action:{
                                selectedView = 0
                                naviTitle = "Book"
                                
                            })
                            Button("NeighborBook", action:{
                                selectedView = 1
                                naviTitle = "NeighborBook"
                            })
                        }
                        .foregroundColor(.mainBlue)
                        .font(Font.custom("S-CoreDream-6Bold", size: 18))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedView == 1 {
                        Button {
                            showDistance = true
                        } label: {
                            Image("controls-alt-p")
                                
                        }
                            .confirmationDialog("거리 설정", isPresented: $showDistance) {
                                Button("3Km") {
                                    setDistance = 3
                                }
                                Button("5Km") {
                                    setDistance = 5
                                }
                                Button("10Km") {
                                    setDistance = 10
                                }
                            }
                        
                    }
                }
            }
            
            
        }
}

struct FirstTabView_Previews: PreviewProvider {
    static var previews: some View {
        FirstTabView()
    }
}
