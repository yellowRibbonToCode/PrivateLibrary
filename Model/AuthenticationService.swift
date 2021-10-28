import Firebase

class AuthenticationService: ObservableObject {
  @Published var user: User?
  var cancellable: AuthStateDidChangeListenerHandle?

  init() {
    cancellable = Auth.auth().addStateDidChangeListener { (_, user) in
      if let user = user {
        logger.event("Got user: \(user.uid)")
        self.user = User(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName
        )
      } else {
        self.user = nil
      }
    }
  }

  func signUp(
    email: String,
    password: String,
    handler: @escaping AuthDataResultCallback
  ) {
    Auth.auth().createUser(withEmail: email, password: password, completion: handler)
  }

  func signIn(
    email: String,
    password: String,
    handler: @escaping AuthDataResultCallback
  ) {
    Auth.auth().signIn(withEmail: email, password: password, completion: handler)
  }

  func signOut() throws {
    try Auth.auth().signOut()
    self.user = nil
  }
}
