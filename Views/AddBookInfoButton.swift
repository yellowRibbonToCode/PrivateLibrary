//
//  AddBookInfoButton.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/04.
//

import SwiftUI

struct AddBookInfoButtonImage: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 50, height: 50)
            Image(systemName: "plus")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .scaledToFit()
        }
    }
}

struct AddBookInfoButton_Previews: PreviewProvider {
    static var previews: some View {
        AddBookInfoButtonImage()
    }
}
