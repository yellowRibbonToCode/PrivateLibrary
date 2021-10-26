//
//  ImageGridView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/26.
//

import SwiftUI

struct ImageGridView: View {
    let columns: [GridItem] = Array(repeating: GridItem(), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(ModelData().library) { libModel in
                        NavigationLink(destination: DetailView(libModel: libModel)) {
                            ImageRow(libModel: libModel)
                                .frame(width: 100, height: 100)
                                .padding(25)
                                .foregroundColor(Color(red: 52/255, green: 57/255, blue: 133/255))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color(red: 236/255, green: 234/255, blue: 235/255),
                                                lineWidth: 4)
                                        .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255),
                                                radius: 2, x: -2, y: -2)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 15)
                                        )
                                        .shadow(color: Color.white, radius: 3, x: 5, y: 5)
                                        .clipShape(
                                            RoundedRectangle(cornerRadius: 15)
                                        )
                                )
                                .background(Color(red: 236/255, green: 234/255, blue: 235/255))
                                .cornerRadius(20)
                            
                        }
                    }
                }
            }
        }
    }
}



struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}
