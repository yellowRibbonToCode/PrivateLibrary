//import Firebase
//
//class AuthenticationService: ObservableObject {
//  @Published var user: User?
//  var cancellable: AuthStateDidChangeListenerHandle?
//
//  init() {
//    cancellable = Auth.auth().addStateDidChangeListener { (_, user) in
//      if let user = user {
//        logger.event("Got user: \(user.uid)")
//        self.user = User(
//          uid: user.uid,
//          email: user.email,
//          displayName: user.displayName
//        )
//      } else {
//        self.user = nil
//      }
//    }
//  }
//
//  func signUp(
//    email: String,
//    password: String,
//    handler: @escaping AuthDataResultCallback
//  ) {
//    Auth.auth().createUser(withEmail: email, password: password, completion: handler)
//  }
//
//  func signIn(
//    email: String,
//    password: String,
//    handler: @escaping AuthDataResultCallback
//  ) {
//    Auth.auth().signIn(withEmail: email, password: password, completion: handler)
//  }
//
//  func signOut() throws {
//    try Auth.auth().signOut()
//    self.user = nil
//  }
//}
import Foundation
import Firebase

// 1
class AuthenticationService: ObservableObject {
  // 2
  @Published var user: User?
  private var authenticationStateHandler: AuthStateDidChangeListenerHandle?

  // 3
  init() {
    addListeners()
  }

  // 4
  static func signIn() {
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously()
    }
  }

  private func addListeners() {
    // 5
    if let handle = authenticationStateHandler {
      Auth.auth().removeStateDidChangeListener(handle)
    }

    // 6
    authenticationStateHandler = Auth.auth()
      .addStateDidChangeListener { _, user in
        self.user = user
      }
  }
}
