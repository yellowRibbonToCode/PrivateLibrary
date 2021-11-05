//
//  CircleImageView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/02.
//

import SwiftUI

struct CircleImageView: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .clipShape(Circle())
            .frame(width: width, height: height)
            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(image: UIImage(systemName: "person")!, width: 100, height: 100)
    }
}
