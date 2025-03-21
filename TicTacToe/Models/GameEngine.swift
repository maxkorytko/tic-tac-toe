//
//  GameEngine.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

/// Performs game computations.
struct GameEngine {
    private let resultQueue: DispatchQueue
    private let workQueue: DispatchQueue

    init(
        workQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.resultQueue = DispatchQueue(label: "\(String(describing: Self.self))-ResultQueue")
        self.workQueue = workQueue
    }

    func computeGameStatus(
        game: Game,
        completionQueue: DispatchQueue = .main,
        completion: @escaping (Game.Status) -> Void
    ) {
        var winner: Player?
        let dispatchGroup = DispatchGroup()

        // Check rows.
        dispatchGroup.enter()
        workQueue.async {
            if
                let winningRow = game.board.rows.first(where: allMatchingSquares),
                let owner = winningRow.first?.owner
            {
                resultQueue.async {
                    winner = owner
                }
            }
            dispatchGroup.leave()
        }

        // Check columns.
        dispatchGroup.enter()
        workQueue.async {
            if
                let winningColumn = columns(game.board).first(where: allMatchingSquares),
                let owner = winningColumn.first?.owner {
                resultQueue.async {
                    winner = owner
                }
            }
            dispatchGroup.leave()
        }

        // Check diagonals.
        dispatchGroup.enter()
        workQueue.async {
            if
                let winningDiagonal = diagonals(game.board).first(where: allMatchingSquares),
                let owner = winningDiagonal.first?.owner {
                resultQueue.async {
                    winner = owner
                }
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: resultQueue) {
            if let winner = winner {
                completionQueue.async { completion(.over(winner)) }
            } else if containsUnownedSquares(game.board) == false {
                completionQueue.async { completion(.over(nil)) }
            } else {
                completionQueue.async { completion(.active) }
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
