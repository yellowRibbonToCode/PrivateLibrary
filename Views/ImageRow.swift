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
        VStack {
            libModel.image
                .resizable()
        }
    }
}

struct ImageRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImageRow(libModel: ModelData().library[0])
            ImageRow(libModel: ModelData().library[1])
            
        }
        .previewLayout(.fixed(width: 300, height: 300))
    }
}
