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
    @State var selectedView = UserDefaults.standard.integer(forKey: "FirstView")
    @State var naviTitle = "Book"
    @State var setDistance = 0.0
    @State var showDistance = false
    @State var neighborGridView = NeighborGridView()
    
    var body: some View {
        
            VStack{
                if selectedView == 0{
                    TestBookmarkView()
                        .onAppear {
                            naviTitle = "Book"
                        }
                }
                else if selectedView == 1{
                    neighborGridView
                        .onAppear {
                            naviTitle = "NeighborBook"
                        }
                }
                else if selectedView == 2{
                    neighborGridView
                }
                else if selectedView == 3{
                    neighborGridView
                }
                else {
                    neighborGridView
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text(naviTitle)
                            .font(.system(size: 32, weight: .bold))
                        Menu("⌵") {
                            Button("Book", action:{
                                selectedView = 0
                                UserDefaults.standard.set(selectedView, forKey: "FirstView")
                                naviTitle = "Book"
                                
                            })
                            Button("NeighborBook", action:{
                                selectedView = 1
                                UserDefaults.standard.set(selectedView, forKey: "FirstView")
                                naviTitle = "NeighborBook"
                            })
                        }
                        .foregroundColor(.mainBlue)
                        .font(Font.custom("S-CoreDream-6Bold", size: 18))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selectedView != 0 {
                        Button {
                            showDistance = true
                        } label: {
                            Image("controls-alt-p")
                                
                        }
                            .confirmationDialog("거리 설정", isPresented: $showDistance) {
                                Button("3Km") {
                                    setDistance = 3.0
                                    UserDefaults.standard.set(setDistance, forKey: "range")
                                    selectedView = 2
                                }
                                Button("5Km") {
                                    setDistance = 5.0
                                    UserDefaults.standard.set(setDistance, forKey: "range")
                                    selectedView = 3
                                }
                                Button("10Km") {
                                    setDistance = 10.0
                                    UserDefaults.standard.set(setDistance, forKey: "range")
                                    selectedView = 4
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
