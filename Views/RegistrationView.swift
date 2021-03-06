//
//  RegistrationView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

struct RegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    @State var username: String = ""
    @State var registerError: String?
    @State var registerSuccess: Bool = false
    @State var privacyAgree: Bool = false
    
    @State var uid: String = ""
    @State var sendEmail: Bool = false
    
    fileprivate func emailTextField() -> some View {
        return TextField("이메일 주소", text: $email)
        
            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
            .padding()
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .frame(width: 240, height: 35)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainBlue, lineWidth: 1)
            )
    }
    
    fileprivate func usernameTextField() -> some View {
        return TextField("이름", text: $username)
            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
        
            .padding()
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .frame(width: 240, height: 35)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainBlue, lineWidth: 1)
            )
    }
    
    fileprivate func passwordTextField() -> some View {
        return SecureField("비밀번호", text: $password)
            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
            .padding()
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .frame(width: 240, height: 35)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainBlue, lineWidth: 1)
            )
    }
    
    fileprivate func passwordConfirmTextField() -> some View {
        return SecureField("비밀번호 확인", text: $passwordConfirm)
            .font(Font.custom("S-CoreDream-2ExtraLight", size: 13))
            .padding()
            .disableAutocorrection(true)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .frame(width: 240, height: 35)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.mainBlue, lineWidth: 1)
            )
    }
    
    fileprivate func registerButton() -> some View {
        return Button(action: {signUp()}) {
            Text("회원가입")
                .font(Font.custom("S-CoreDream-5Medium", size: 15))
                .padding()
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .frame(width: 240, height: 35)
                .foregroundColor(.white)
                .background(Color.mainBlue)
                .cornerRadius(20)
        }
    }
    
    fileprivate func privacyButton() -> some View {
        return(
            HStack{
                Button(action: {
                    
                    self.privacyAgree.toggle()
                    
                }) {
                    Image(systemName: privacyAgree ? "rectangle.fill" : "rectangle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.mainBlue)
                }
                
                NavigationLink(destination: Privacy(privacyAgree: $privacyAgree)) {
                    Text("개인정보 처리방침 및 이용약관에 동의합니다 >")
                }
            }
        )
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        if registerSuccess{
            VStack{}
            .onAppear(){
                self.presentationMode.wrappedValue.dismiss()}
        }
        else {
            ScrollView {
                VStack (spacing: 0) {
                    Image("loginIcon")
                        .padding()
                    emailTextField()
                        .padding(.top, 30)
                    usernameTextField()
                        .padding(.top, 21)
                    passwordTextField()
                        .padding(.top, 21)
                    passwordConfirmTextField()
                        .padding(.top, 21)
                    privacyButton()
                        .padding(.top, 21)
                    registerButton()
                        .padding(.top, 21)
                    Text(registerError ?? " ")
                        .foregroundColor(.red)
                        .padding()
                }
                .padding()
                
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(.mainBlue)
                })
                
                .alert(isPresented: $sendEmail) {
                    Alert(title: Text("인증 이메일이 전송되었습니다."), message: Text(""), dismissButton: .default(Text("확인"), action: {
                        registerSuccess = true
                    }))
                }
            }
            .onTapGesture {
                UIApplication.shared.closeKeyboard()
            }

        }
    }
    
    private func addUsername() {
        var db: Firestore!
        
        db = Firestore.firestore()
        do {
            try db.collection("users").document(uid as String).setData(from: [
                "email": email,
                "name": username])
        } catch let error {
            print("Error writing username to Firestore: \(error)")
        }
    }
    
    func duplicateName(completionHandler: @escaping (Bool) -> Void) {
        var isunique = false
        db.collection("users").getDocuments() {
            querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                isunique = true
                for document in querySnapshot!.documents {
                    let name = document.get("name") as? String ?? ""
                    if name == username {
                        registerError = "중복된 아이디입니다."
                        isunique = false
                    }
                }
            }
            completionHandler(isunique)
        }
    }
    func signUp(){
        registerError = " "
        if ((password == passwordConfirm) && privacyAgree) {
            self.duplicateName() { isNotDup in
                if (isNotDup){
                    Auth.auth().createUser(withEmail: self.email, password: self.password) { (user, error) in
                        if(user != nil){
                            Auth.auth().currentUser?.sendEmailVerification()
                            uid = user?.user.uid ?? " "
                            addUsername()
                            sendEmail = true
                        }else{
                            registerError = error?.localizedDescription
                            print("register failed")
                        }
                    }
                }
            }
        }
        else {
            if password != passwordConfirm {
                registerError = "비밀번호가 일치하지 않습니다."
            }
            else {
                registerError = "개인정보 처리방침 및 이용약관에 동의가 필요합니다."
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
