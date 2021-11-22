//
//  LoginView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/25.
//

import SwiftUI
import Firebase
import FirebaseAuth


struct LoginStatusKey: EnvironmentKey {
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
    @State var loginError: String?
    
    
    fileprivate func emailTextField() -> some View {
        return HStack {
            TextField("이메일 주소", text: $username)
                .padding()
                .frame(width: 240, height: 35)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mainBlue, lineWidth: 1)
                )
        }
    }
    
    fileprivate func passwordTextField() -> some View {
        return HStack {
            SecureField("비밀번호", text: $password)
                .padding()
                .frame(width: 240, height: 35)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mainBlue, lineWidth: 1)
                )
        }
        .padding(.top, 21)
    }
    
    fileprivate func loginButton() -> some View {
        return Button(action: {login()}) {
            Text("로그인")
                .frame(width: 240, height: 35)
                .background(Color.mainBlue)
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
    
    fileprivate func registerButton() -> some View {
        return NavigationLink(destination: RegistrationView()) { Text("회원가입")
                .frame(width: 240, height: 35)
                .background(Color.mainBlue)
                .cornerRadius(20)
                .foregroundColor(.white)
                .padding(.top, 20)
        }
    }
    
    fileprivate func forgotButton() -> some View {
        return NavigationLink(destination: ForgotView()) { Text("비밀번호 찾기")
                .font(Font.custom("S-CoreDream-4Regular", size: 14))
                .foregroundColor(.mainBlue)
                .fontWeight(.medium)
                .padding(.top, 11)
                .padding(.bottom,46)
        }
    }
    
    var body: some View {
        if loginSuccess{
            HomeView()
                .environment(\.loginStatus, $loginSuccess)
        }
        else{
            NavigationView {
                VStack (alignment: .center, spacing: 0){
                    Image("loginIcon")
                        .padding(.bottom, 30)
                    VStack (spacing: 0) {
                        Group{
                            emailTextField()
                            passwordTextField()
                        }
                        .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
                        HStack {
                            Spacer()
                            forgotButton()
                                .font(Font.custom("S-CoreDream-4Regular", size: 14))
                        }
                        .frame(width: 240)
                        Group {
                            loginButton()
                            registerButton()
                        }
                        .font(Font.custom("S-CoreDream-5Medium", size: 15))
                        
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
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (user, error) in
            if user != nil{
                UserDefaults.standard.set(self.username, forKey: "id")
                UserDefaults.standard.set(self.password, forKey: "password")
                UserDefaults.standard.set(true, forKey: "islogin")
                self.username = ""
                self.password = ""
                loginSuccess = true
            }else{
                loginError = error?.localizedDescription
            }
        }
    }
    
    func autoLogin() {
        loginError = " "
        if UserDefaults.standard.bool(forKey: "islogin")
        {
            loginSuccess = true
        }
//        if (UserDefaults.standard.string(forKey: "id") != "" && UserDefaults.standard.string(forKey: "id") != nil)
//        {
//            self.username = UserDefaults.standard.string(forKey: "id")!
//            self.password = UserDefaults.standard.string(forKey: "password")!
//            login()
//        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
