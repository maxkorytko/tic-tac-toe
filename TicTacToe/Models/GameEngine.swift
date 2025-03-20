//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

struct GameEngine {
    private let queue: DispatchQueue

    private static func createQueue() -> DispatchQueue {
        DispatchQueue(label: "GameEngineQueue")
    }

    init(queue: DispatchQueue = Self.createQueue()) {
        self.queue = queue
    }

    func computeWinner(game: Game, completion: @escaping (Player?) -> Void) {
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

            completion(winner)
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
}
