//
//  UILabel+Style.swift
//  Core
//
//  Created by User on 1/6/2567 BE.
//

import Foundation
import UIKit

public enum Typo {
    case h1
    case h2
    case content
    case footer
    case button
}

public extension UILabel {
    
    func applyStyle(typo: Typo) {
        applyFontStyle(typo: typo)
        applyColorStyle(typo: typo)
    }

    func applyFontStyle(typo: Typo) {
        switch typo {
        case .h1:
            font = UIFont.boldSystemFont(ofSize: 24)
        case .h2:
            font = UIFont.boldSystemFont(ofSize: 16)
        case .content:
            font = UIFont.systemFont(ofSize: 16)
        case .footer:
            font = UIFont.systemFont(ofSize: 12)
        case .button:
            font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    func applyColorStyle(typo: Typo) {
        switch typo {
        case .h1:
            textColor = .black
        case .h2:
            textColor = .black
        case .content:
            textColor = .black
        case .footer:
            textColor = .darkGray
        case .button:
            textColor = .black
        }
    }
    
}
