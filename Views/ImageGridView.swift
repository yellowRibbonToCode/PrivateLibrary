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
                            
                            
                        }
                        
                    }
                }
            }
            
        }
        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
}



struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView()
    }
}
