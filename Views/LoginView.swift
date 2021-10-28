//
//  LoginView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State private var loginSuccess: Bool = false
    @State private var createUser: Bool = false
    
    
    var body: some View {
        if loginSuccess{
            HomeView()
        }
        else if createUser{
            RegistrationView()
        }
        else{
            ZStack {
                Image("books-bg")
                    .grayscale(0.5)
                    .blur(radius: 8)
                VStack (alignment: .center){
                    Group {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.white)
                            
                            TextField("E-Mail", text: $username)
                                .padding()
                                .frame(width: 230, height: 40)
                                .disableAutocorrection(true)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .background(Color.white
                                                .opacity(0.5)
                                                .cornerRadius(10))
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.white)
                            SecureField("Password", text: $password)
                                .padding()
                                .frame(width: 230, height: 40)
                                .background(Color.white
                                                .opacity(0.5)
                                                .cornerRadius(10))
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                    VStack {
//                        Button(action: {loginSuccess = true}) {
                        Button(action: {login()}) {
                            Text("Login")
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                                .padding()
                        }
                        Button(action: {createUser = true}) {
                            Text("Register")
                                .font(.headline)
                            
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    
    func login(){
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (user, error) in
            if user != nil{
                print("login success")
                print(username)
            }else{
                print(error)
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
