//
//  Gameboard.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-19.
//

import Foundation

struct Gameboard {
    private(set) var rows: [[Gameboard.Square]] = {
        (1...3).map { _ in
            (1...3).map { _ in
                Gameboard.Square(owner: nil)
            }
        }
    }()

    subscript(row: Int, column: Int) -> Square? {
        get {
            rows[safe: row]?[safe: column]
        }
        set {
            rows[safe: row]?[safe: column] = newValue
        }
    }
}

// MARK: - Array

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
