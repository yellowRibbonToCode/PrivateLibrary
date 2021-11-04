//
//  SushinRepository.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

class SushinRepository: ObservableObject {
    
    private let path: String = "sushins"
    private let store = Firestore.firestore()
    
    @Published var sushins: [Sushin] = []
    
    var userId = ""
    private let authenticationService = AuthenticationService()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.get()
            }
            .store(in: &cancellables)
    }

    func get() {
        store.collection(path)
            .whereField("userId", isEqualTo: userId)
//            .order(by: "created", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error getting cards: \(error.localizedDescription)")
                    return
                }
                
                self.sushins = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Sushin.self)
                } ?? []
            }
    }
    
    func add(_ sushin: Sushin) {
        do {
            var newSushin = sushin
            newSushin.userId = userId
                        print("[before]")

            newSushin.created = Date()
            newSushin.edited = Date()
                        print("[after]")

            _ = try store.collection(path).addDocument(from: newSushin)
        } catch {
            fatalError("Unable to add card: \(error.localizedDescription).")
        }
    }
    
    func update(_ sushin: Sushin) {
        guard let sushinId = sushin.id else { return }
        
        do {
            var newSushin = sushin
//            print("[before]")
            newSushin.edited = Date()
//            print("[after]")
            try store.collection(path).document(sushinId).setData(from: sushin)
        } catch {
            fatalError("Unable to update card: \(error.localizedDescription).")
        }
    }
    
    func remove(_ sushin: Sushin) {
        guard let sushinId = sushin.id else { return }
        
        store.collection(path).document(sushinId).delete { error in
            if let error = error {
                print("Unable to remove card: \(error.localizedDescription)")
            }
        }
    }
}
