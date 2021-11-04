//
//  SushinListViewModel.swift
//  PrivateLibrary
//
//  Created by SSB on 2021/11/03.
//

import Foundation
import Combine

// 2
class SushinListViewModel: ObservableObject {
  // 1
  @Published var sushinViewModels: [SushinViewModel] = []
  // 2
  private var cancellables: Set<AnyCancellable> = []

  // 3
  @Published var sushinRepository = SushinRepository()

  init() {
    // 1
    sushinRepository.$sushins.map { sushins in
      sushins.map(SushinViewModel.init)
    }
    // 2
    .assign(to: \.sushinViewModels, on: self)
    // 3
    .store(in: &cancellables)
  }

  // 4
  func add(_ sushin: Sushin) {
    sushinRepository.add(sushin)
  }
}
