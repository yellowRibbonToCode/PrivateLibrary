//
//  SushinViewModel.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import Foundation
import Combine

class SushinViewModel: ObservableObject, Identifiable {
    
    private let sushinRepository = SushinRepository()
    @Published var sushin: Sushin
    private var cancellables: Set<AnyCancellable> = []
    var id = ""
    
    init(sushin: Sushin) {
        self.sushin = sushin
        $sushin
            .compactMap { $0.id }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func update(sushin: Sushin) {
        sushinRepository.update(sushin)
    }
    
    func remove() {
        sushinRepository.remove(sushin)
    }
}
