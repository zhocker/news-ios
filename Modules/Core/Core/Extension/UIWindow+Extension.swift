//
//  UIWindow+Extension.swift
//  Components
//
//  Created by User on 30/5/2567 BE.
//

import Foundation
import UIKit

public extension UIWindow {
    public func animateTransition(duration: TimeInterval = 0.37,
                                  options: UIView.AnimationOptions = [.transitionCrossDissolve]) {
        UIView.transition(with: self, duration: duration, options: options, animations: nil)
    }
}

