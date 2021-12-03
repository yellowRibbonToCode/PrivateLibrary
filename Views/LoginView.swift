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
    @State var authEmailButton: Bool = false
    @State var sendEmail: Bool = false
    
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
                .onAppear {
                    db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { doc, err in
                        if doc != nil {
                            let arr = doc!.get("blockuseruid") as? [String]
                            UserDefaults.standard.removeObject(forKey: "blockuseruid")
                            if arr != nil {
                                UserDefaults.standard.set(arr, forKey: "blockuseruid")
                            }
                        }
                    }
                }
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
                        
                        HStack {
                            Text(loginError ?? " ")
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .padding()
                            if authEmailButton {
                                Button {
                                    sendAuthEmail()
                                } label: {
                                    Text("재전송")
                                }
                            }
                        }
                        .font(.footnote)
                    }
                    .padding(.bottom,140)
                }
            }
            .onAppear {
                autoLogin()
            }
            .alert(isPresented: $sendEmail) {
                Alert(title: Text("인증 이메일이 전송되었습니다."), message: Text(""), dismissButton: .default(Text("확인"), action: {
                    sendEmail = false
                }))
            }
        }
    }
    
    func login(){
        Auth.auth().languageCode = "ko"
        Auth.auth().signIn(withEmail: self.username, password: self.password) { (user, error) in
            
            if user != nil{
                if Auth.auth().currentUser?.isEmailVerified == false {
                    loginError = "이메일 인증이 필요합니다."
                    authEmailButton = true
                    return
                }
                UserDefaults.standard.set(self.username, forKey: "id")
                UserDefaults.standard.set(self.password, forKey: "password")
                UserDefaults.standard.set(true, forKey: "islogin")
                self.username = ""
                self.password = ""
                loginSuccess = true
            }else{
                loginError = error?.localizedDescription
                authEmailButton = false
            }
        }
    }
    
    func sendAuthEmail() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { error in
            if (error == nil)
            {
                loginError = ""
                authEmailButton = false
                sendEmail = true
            }
        })
    }
    
    func autoLogin() {
        loginError = " "
        if UserDefaults.standard.bool(forKey: "islogin")
        {
            if ((Auth.auth().currentUser?.isEmailVerified) != nil) {
                loginSuccess = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
