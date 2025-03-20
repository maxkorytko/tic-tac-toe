//
//  Array+Extensions.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

extension Array {
    subscript(safe index: Array.Index) -> Element? {
        get {
            if index >= startIndex, index < endIndex {
                return self[index]
            }
            return nil
        }
        set {
            if let newValue = newValue, index >= startIndex, index < endIndex {
                self[index] = newValue
            }
        }
    }
}
