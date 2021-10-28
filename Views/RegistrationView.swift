//
//  RegistrationView.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/26.
//

import SwiftUI
import FirebaseAuth

struct RegistrationView: View {
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            Text("Create an account")
                .font(.title)
            TextField("Email", text: $email)
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .autocapitalization(.none)
            Button(
                "Create",
                action: {signUp()}
            )
            
            Divider()
            
            Text("An account allows to save and access notes across devices.")
                .font(.footnote)
                .foregroundColor(.gray)
            Spacer()
        }.padding()
    }
    func signUp(){
        Auth.auth().createUser(withEmail: self.email, password: self.password) { (user, error) in
            if(user != nil){
                print("register successs")
                print(email)
            }else{
                print("register failed")
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
