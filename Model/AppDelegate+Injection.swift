//
//  AppDelegate+Injection.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/28.
//

import Foundation
import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
    register { AuthenticationService() }.scope(application)
  }
}
