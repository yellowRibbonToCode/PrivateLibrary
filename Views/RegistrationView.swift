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
    @State var username: String = ""
    @State var registerError: String?
    @State var registerSuccess: Bool = false
    
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
    
    fileprivate func usernameTextField() -> some View {
        return HStack {
            Image(systemName: "person.crop.circle")
                .foregroundColor(.white)
            
            TextField("Username", text: $username)
                .padding()
                .frame(width: 230, height: 40)
                .disableAutocorrection(true)
            //                .keyboardType(.emailAddress)
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
        .padding(.bottom, 20)
    }
    
    fileprivate func registerButton() -> some View {
        return Button(action: {signUp()}) {
            Text("Register")
                .font(.headline)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .padding()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        if registerSuccess{
            LoginView()
        }
        else {
            ZStack {
                Image("books-bg")
                    .grayscale(0.5)
                    .blur(radius: 8)
                VStack {
                    Text("Create an account")
                        .font(.title)
                        .foregroundColor(.white)
                    emailTextField()
                    usernameTextField()
                    passwordTextField()
                    registerButton()
                    
                    Text(registerError ?? " ")
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
    
    //
    private func addUsername() {
        var ref: DocumentReference? = nil
        var db: Firestore!
        
        db = Firestore.firestore()
        // [START add_alan_turing]
        // Add a second document with a generated ID.
        ref = db.collection("libData").addDocument(data: [
            "email": email,
            "name": username
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        // [END add_alan_turing]
    }
    
    func signUp(){
        Auth.auth().createUser(withEmail: self.email, password: self.password) { (user, error) in
            if(user != nil){
                print("register successs")
                print(email)
                addUsername()
                registerSuccess = true
            }else{
                registerError = error?.localizedDescription
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
