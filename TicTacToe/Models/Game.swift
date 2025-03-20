//
//  Game.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

final class Game {
    let player1: Player
    let player2: Player

    private(set) var activePlayer: Player?
    private let gameEngine: GameEngine
    private(set) var board: Gameboard = .init()

    init(gameEngine: GameEngine = .init(), player1: Player, player2: Player) {
        self.gameEngine = gameEngine
        self.player1 = player1
        self.player2 = player2
        self.activePlayer = player1
    }

    func advance() {
        if activePlayer == player1 {
            activePlayer = player2
        } else {
            activePlayer = player1
        }
    }

    func checkWinner(completion: @escaping (Player?) -> Void) {
        gameEngine.computeWinner(game: self, completion: completion)
    }

    /// Selects a square located in the specified row and column.
    /// - Returns: True if the square has been selected or false otherwise.
    @discardableResult
    func selectSquare(row: Int, column: Int) -> Bool {
        guard var square = board[row, column] else {
            return false
        }

        if square.owner != nil {
            return false
        }

        square.owner = activePlayer
        board[row, column] = square

        return true
    }
}
