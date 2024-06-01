//
//  CollectionItem+Safe.swift
//  Core
//
//  Created by User on 1/6/2567 BE.
//

import Foundation

public extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func takeSafe(index : Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
}
