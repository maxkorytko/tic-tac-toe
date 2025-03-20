//
//  GameboardCell.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-19.
//

import Foundation

extension Gameboard {
    struct Square: Hashable {
        let identifier: UUID = UUID()
        var owner: Player?
    }
}
