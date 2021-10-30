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
            Image(systemName: "envelope")
                .foregroundColor(.white)
            
            TextField("E-Mail", text: $email)
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
    
    fileprivate func sendButton() -> some View {
        return Button(action: {send()}) {
            Text("Send")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .padding()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        if sendSuccess{
            LoginView()
        }
        else {
            ZStack {
                Image("books-bg")
                    .grayscale(0.5)
                    .blur(radius: 8)
                VStack {
                    Text("Reset password")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(EdgeInsets(top: -200, leading: 0, bottom: 0, trailing: 0))
                        .foregroundColor(.white)
                    Text("Enter your email for reset password")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    emailTextField()
                    sendButton()
                    
                    Text(sendError ?? " ")
                        .foregroundColor(.red)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                })
            }
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
