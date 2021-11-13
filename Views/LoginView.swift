//
//  LoginView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

class Backend: ObservableObject {
    @Published var user = Auth.auth().currentUser
    let imagesRef = Storage.storage().reference().child("images")
    let users = Firestore.firestore().collection("users")
    let libData = Firestore.firestore().collection("libData")
    let chatings = Firestore.firestore().collection("chatings")
}

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var loginError: String?
    @StateObject var backend = Backend()
    
    fileprivate func emailTextField() -> some View {
        return HStack {
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
    }
    
    fileprivate func passwordTextField() -> some View {
        return HStack {
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
        .padding(.bottom, 50)
    }
    
    fileprivate func loginButton() -> some View {
        return Button(action: {login()}) {
            Text("Login")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .padding()
        }
    }
    
    fileprivate func registerButton() -> some View {
        return NavigationLink(destination: RegistrationView()) { Text("Register")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .padding()
        }
    }
    
    fileprivate func forgotButton() -> some View {
        return NavigationLink(destination: ForgotView()) { Text("Forgot Pass?")
                .font(.subheadline)
                .foregroundColor(.white)
                .fontWeight(.heavy)
        }
    }
    
    var body: some View {
        if let _ = self.backend.user {
            HomeView()
                .environmentObject(self.backend)
        } else {
            NavigationView {
                ZStack {
                    Image("books-bg")
                        .grayscale(0.5)
                        .blur(radius: 8)
                    VStack (alignment: .center){
                        VStack {
                            emailTextField()
                            passwordTextField()
                            HStack {
                                Spacer()
                                    .frame(width: 140)
                                forgotButton()
                                    .offset(x: 0, y: -40)
                            }
                            
                            loginButton()
                            registerButton()
                            Text(loginError ?? " ")
                                .font(.footnote)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (user, error) in
            if user != nil{
                print("login success")
                print(username)
                username = ""
                password = ""
                backend.user = Auth.auth().currentUser
            }else{
                loginError = error?.localizedDescription
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
