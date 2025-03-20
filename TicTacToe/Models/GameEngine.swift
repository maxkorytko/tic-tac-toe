//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

/// Performs game computations.
struct GameEngine {
    private let queue: DispatchQueue

    private static func createQueue() -> DispatchQueue {
        DispatchQueue(label: "GameEngineQueue")
    }

    init(queue: DispatchQueue = Self.createQueue()) {
        self.queue = queue
    }

    func computeGameStatus(game: Game, completion: @escaping (Game.Status) -> Void) {
        queue.async {
            let winner: Player?

            if let winningRow = game.board.rows.first(where: allMatchingSquares) {
                winner = winningRow.first?.owner
            } else if let winningColumn = columns(game.board).first(where: allMatchingSquares) {
                winner = winningColumn.first?.owner
            } else if let winningDiagonal = diagonals(game.board).first(where: allMatchingSquares) {
                winner = winningDiagonal.first?.owner
            } else {
                winner = nil
            }

            if let winner = winner {
                completion(.over(winner))
            } else if containsUnownedSquares(game.board) == false {
                completion(.over(nil))
            } else {
                completion(.active)
            }
        }
    }

    private func columns(_ board: Gameboard) -> [[Gameboard.Square]] {
        var transposedRows = board.rows

        (0..<board.rows.count).forEach { row in
            (row..<board.rows[row].count).forEach { column in
                transposedRows[row][column] = board.rows[column][row]
                transposedRows[column][row] = board.rows[row][column]
            }
        }

        return transposedRows
    }

    private func diagonals(_ board: Gameboard) -> [[Gameboard.Square]] {
        var squares = [[Gameboard.Square]]()

        squares.append({
            (0..<board.rows.count).compactMap { row -> Gameboard.Square? in
                board[row, row]
            }
        }())

        squares.append({
            (0..<board.rows.count).compactMap { row -> Gameboard.Square? in
                board[row, board.rows.count - row - 1]
            }
        }())

        return squares
    }

    private func allMatchingSquares(_ squares: [Gameboard.Square]) -> Bool {
        squares.allSatisfy { square in
            square.owner != nil && square.owner == squares.first?.owner
        }
    }

    private func containsUnownedSquares(_ board: Gameboard) -> Bool {
        board.flattened().contains { $0.owner == nil }
    }
}
