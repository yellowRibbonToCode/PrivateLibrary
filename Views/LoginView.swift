//
//  LoginView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI
import Firebase
import FirebaseAuth


private struct LoginStatusKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var loginStatus : Binding<Bool> {
        get { self[LoginStatusKey.self] }
        set { self[LoginStatusKey.self] = newValue }
    }
}

struct LoginView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State private var loginSuccess: Bool = false
//    @Environment(\.loginStatus) var loginSuccess: Bool
    @State var loginError: String?
    
    
    fileprivate func emailTextField() -> some View {
        return HStack {
//            Image(systemName: "envelope")
//                .foregroundColor(.white)
            
            TextField("이메일 주소", text: $username)
                .padding()
                .frame(width: 250, height: 35)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainBlue, lineWidth: 1)
                    )
        }
//        .padding(.top, 10)
//        .padding(.bottom, 10)
    }
    
    fileprivate func passwordTextField() -> some View {
        return HStack {
//            Image(systemName: "lock")
//                .foregroundColor(.white)
            SecureField("비밀번호", text: $password)
                .padding()
                .frame(width: 250, height: 35)
                .cornerRadius(20)
                .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.mainBlue, lineWidth: 1)
                    )
        }
        .padding(.top, 15)
//        .padding(.bottom, 50)
    }
    
    fileprivate func loginButton() -> some View {
        return Button(action: {login()}) {
            Text("로그인")
                .padding()
                .frame(width: 250, height: 35)
                .background(Color.mainBlue)
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
    
    fileprivate func registerButton() -> some View {
        return NavigationLink(destination: RegistrationView()) { Text("회원가입")
                .padding()
                .frame(width: 250, height: 35)
                .background(Color.mainBlue)
                .cornerRadius(20)
                .foregroundColor(.white)
                .padding(.top, 15)
        }
    }
    
    fileprivate func forgotButton() -> some View {
        return NavigationLink(destination: ForgotView()) { Text("비밀번호 찾기")
                .font(.headline)
                .foregroundColor(.mainBlue)
                .fontWeight(.medium)
                .padding(.bottom,40)
        }
    }
    
    var body: some View {
        if loginSuccess{
            HomeView()
                .environment(\.loginStatus, $loginSuccess)
        }
        else{
            NavigationView {
                    VStack (alignment: .center){
                        Image("lodingIcon")
                            .resizable()
                            .frame(width: 400, height: 170, alignment: .center)
                        VStack {
                            emailTextField()
                            passwordTextField()
                            HStack {
                                Spacer()
                                forgotButton()
                            }
                            .frame(width: 250)
                            loginButton()
                            registerButton()
                            Text(loginError ?? " ")
                                .font(.footnote)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.bottom,140)
                    }
                
            }
            .onAppear {
                autoLogin()
                self.username = ""
                self.password = ""
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (user, error) in
            if user != nil{
                UserDefaults.standard.set(self.username, forKey: "id")
                UserDefaults.standard.set(self.password, forKey: "password")
                loginSuccess = true
            }else{
                loginError = error?.localizedDescription
            }
        }
    }
    
    func autoLogin() {
        if let userid = UserDefaults.standard.string(forKey: "id"){
            self.username = userid
            self.password = UserDefaults.standard.string(forKey: "password")!
            login()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
