//
//  EditView.swift
//  PrivateLibrary
//
//  Created by 김진범 on 2021/11/04.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var profile: Profile
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Button("done") {
                self.presentationMode.wrappedValue.dismiss()
            }
            //photopicker
            //namechaneger
//            TextField()
        }
    }
    
    fileprivate func editProfile() {
        // photo picker
        // 1. remove prev profile
        // 2. upload new profile
    }
    fileprivate func editName() {
        // libdata isequalto <prev usernickname or uid>
        // chage to newuid>
    }
//    fileprivate func editEmail() {
//        // libdata isequalto <prev usernickname or uid>
//        // chage to newuid>
//    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(profile: Profile())
    }
}
