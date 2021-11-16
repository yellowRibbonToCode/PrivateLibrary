//
//  ForgotView.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/10/30.
//

import SwiftUI
import FirebaseAuth

struct ForgotView: View {
    
    @State var email: String = ""
    @State var sendError: String?
    @State var sendSuccess: Bool = false
    
    fileprivate func emailTextField() -> some View {
        return HStack {
            TextField("이메일 주소", text: $email)
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
    
    fileprivate func sendButton() -> some View {
        return Button(action: {send()}) {
            Text("전송")
                .frame(width: 240, height: 35)
                .background(Color.mainBlue)
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        if sendSuccess{
            LoginView()
        }
        else {
            VStack (spacing: 0){
                Image("loginIcon")
                    .padding(.bottom, 30)
                Text("비밀번호를 잊어버리셨나요?")
                    .fontWeight(.heavy)
                    .foregroundColor(.mainBlue)
                    .font(Font.custom("S-CoreDream-4Regular", size: 17))
                Text("가입 시 작성한 이메일로 임시 비밀번호를 보내드립니다.")
                    .padding(.top, 6)
                    .padding(.bottom, 30)
                    .foregroundColor(.mainBlue)
                    .font(Font.custom("S-CoreDream-4Regular", size: 13))
                emailTextField()
                    .font(Font.custom("S-CoreDream-2ExtraLight", size: 12))
                
                sendButton()
                    .padding(.top, 80)
                    .font(Font.custom("S-CoreDream-5Medium", size: 15))
                
                Text(sendError ?? " ")
                    .foregroundColor(.red)
            }
            
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
                    .foregroundColor(.mainBlue)
            })
        }
    }
    
    func send(){
        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
            if (error != nil) {
                sendError = error?.localizedDescription
                print("send fail")
            }else{
                print("send success")
                print(email)
                sendSuccess = true
                
            }
        }
    }
}

struct ForgotView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotView()
    }
}
