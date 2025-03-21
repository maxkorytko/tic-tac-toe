//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by Max Korytko on 2025-03-20.
//

@testable import TicTacToe
import XCTest

final class GameTests: XCTestCase {
    var game: Game!
    var gameEngine: GameEngine!
    let player1: Player = .x(PlayerProfile(name: "John"))
    let player2: Player = .o(PlayerProfile(name: "Stephany"))

    private func makeGame() {
        game = Game(gameEngine: gameEngine, player1: player1, player2: player2)
    }

    override func setUp() {
        super.setUp()

        gameEngine = GameEngine()
        makeGame()
    }

    func testActivePlayerAtGameStart() {
        XCTAssertEqual(game.activePlayer, player1)
    }

    func testAdvance() {
        game.advance()
        XCTAssertEqual(game.activePlayer, player2)
        game.advance()
        XCTAssertEqual(game.activePlayer, player1)
    }

    func testSelectSquare() {
        XCTAssertNil(game.board[0, 0]?.owner)
        XCTAssertTrue(game.selectSquare(row: 0, column: 0))
        XCTAssertEqual(game.board[0, 0]?.owner, player1)

        game.advance()

        XCTAssertFalse(game.selectSquare(row: 0, column: 0))
        XCTAssertEqual(game.board[0, 0]?.owner, player1)

        XCTAssertTrue(game.selectSquare(row: 1, column: 1))
        XCTAssertEqual(game.board[1, 1]?.owner, player2)

        XCTAssertFalse(game.selectSquare(row: 99, column: 99))
    }

    func testGameStatus_active() {
        var gameStatus: Game.Status?
        let expectation = XCTestExpectation(description: "Game Status")

        game.checkStatus { status in
            gameStatus = status
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(gameStatus, .active)
    }

    func testWinner_rows() {
        (0..<game.board.rows.count).forEach { row in
            makeGame()

            var expectedWinner = player1
            if row == 1 {
                game.advance()
                expectedWinner = player2
            }

            (0..<game.board.rows.count).forEach { column in
                game.selectSquare(row: row, column: column)
            }

            assertWinner(expectedWinner, game: game)
        }
    }

    func testWinner_columns() {
        (0..<game.board.rows.count).forEach { column in
            makeGame()

            var expectedWinner = player1
            if column == 1 {
                game.advance()
                expectedWinner = player2
            }

            (0..<game.board.rows.count).forEach { row in
                game.selectSquare(row: row, column: column)
            }

            assertWinner(expectedWinner, game: game)
        }
    }

    func testWinner_diagonals() {
        (0..<game.board.rows.count).forEach { row in
            game.selectSquare(row: row, column: row)
        }
        assertWinner(player1, game: game)

        makeGame()
        game.advance()

        [(0, 2), (1, 1), (2, 0)].forEach { squareCoordinates in
            game.selectSquare(row: squareCoordinates.0, column: squareCoordinates.1)
        }
        assertWinner(player2, game: game)
    }

    func testWinner_noWinner() {
        (0..<game.board.rows.count).forEach { row in
            if row == 1 {
                game.advance()
            }

            (0..<game.board.rows.count).forEach { column in
                game.selectSquare(row: row, column: column)
                game.advance()
            }
        }

        var gameStatus: Game.Status?
        let expectation = XCTestExpectation(description: "Game Status")

        game.checkStatus { status in
            gameStatus = status
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        guard case let .over(winner) = gameStatus else {
            XCTFail("Unexpected game status")
            return
        }

        XCTAssertNil(winner)
    }

    private func assertWinner(
        _ player: Player?,
        game: Game,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var winner: Player?
        let expectation = XCTestExpectation(description: "Check Winner")

        game.checkStatus { status in
            if case let .over(winningPlayer) = status {
                winner = winningPlayer
            }

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(player, winner, file: file, line: line)
    }
}
