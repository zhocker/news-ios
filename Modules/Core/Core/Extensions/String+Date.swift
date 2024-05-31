//
//  String+Date.swift
//  news-ios
//
//  Created by User on 31/5/2567 BE.
//

import Foundation
extension String {
    
    func displayDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: self) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return ""
    }

}
