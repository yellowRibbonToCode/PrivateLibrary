//
//  NavigationBarGestureControl.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/10/29.
//

import Foundation
import UIKit

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
