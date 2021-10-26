//
//  LoginView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    
    
    var body: some View {
        VStack (alignment: .center){
            Icon()
                .padding(.bottom, 50)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(Color(hue: 0.377, saturation: 0.875, brightness: 0.4))
                TextField("E-Mail", text: $username)
                    .padding()
                    .frame(width: 230, height: 40)
                    .disableAutocorrection(true)
                    .keyboardType(.emailAddress)
            }.overlay(
                VStack{
                Divider()
                    .offset(x:0, y: 20)
            })
            HStack {
                Image(systemName: "lock")
                    .foregroundColor(Color(hue: 0.377, saturation: 0.875, brightness: 0.4))
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 230, height: 40)
            }.overlay(
                VStack{
                Divider()
                    .offset(x:0, y: 20)
            })
            //                .padding(.bottom, 20)
            Button(action: {print("Button tapped")}) {
                Text("LOGIN")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 40)
                    .background(Color(hue: 0.377, saturation: 0.875, brightness: 0.4))
                    .cornerRadius(15.0)
            }
            .padding(.top, 30)
            Divider()
                .padding(30)
            Button(action: {print("Button tapped")}) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(Color(hue: 0.377, saturation: 0.875, brightness: 0.4))
                    .padding()
                    .frame(width: 220, height: 40)
                    .overlay(RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hue: 0.377, saturation: 0.875, brightness: 0.4), lineWidth: 5))
//                    .border(Color(hue: 0.377, saturation: 0.875, brightness: 0.4)
//                            , width: 5)
                
            }
            
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
