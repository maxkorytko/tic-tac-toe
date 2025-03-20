//
//  ViewController.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-19.
//

import UIKit

final class GameViewController: UIViewController {
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    private var gameboardViewController: GameboardViewController? {
        didSet {
            gameboardViewController?.delegate = self
        }
    }

    private var game: Game!

    private static func makeGame() -> Game {
        Game(
            player1: .x(PlayerProfile(name: "Player 1")),
            player2: .o(PlayerProfile(name: "Player 2"))
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        startNewGame()
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let gameboardViewController = segue.destination as? GameboardViewController {
            self.gameboardViewController = gameboardViewController
        }
    }

    private func advanceGame() {
        game.checkStatus { [weak self] status in
            switch status {
            case .active:
                self?.game.advance()
                self?.showActivePlayer()
            case let .over(winner):
                self?.finishGame(winner)
            }
        }
    }

    private func finishGame(_ winner: Player?) {
        game.paused = true

        if let winner = winner {
            show(winner)
        } else {
            statusLabel.text = "Game over"
        }
    }

    private func show(_ winner: Player) {
        let alertController = UIAlertController(
            title: "\(winner.profile.name) wins!",
            message: "Start a new game?",
            preferredStyle: .alert
        )

        alertController.addAction(.init(title: "Yes", style: .default) { _ in
            self.startNewGame()
        })

        alertController.addAction(
            .init(title: "No", style: .cancel)
        )

        present(alertController, animated: true)
    }

    private func showActivePlayer() {
        statusLabel.text = "\(game.activePlayer.profile.name)'s turn"
    }

    private func startNewGame() {
        game = Self.makeGame()
        gameboardViewController?.gameboard = game.board
        showActivePlayer()
    }

    @IBAction func buttonTapped(_ sender: Any) {
        startNewGame()
    }
}

// MARK: - GameboardViewControllerDelegate

extension GameViewController: GameboardViewControllerDelegate {
    func didSelectSquare(row: Int, column: Int) {
        guard game.selectSquare(row: row, column: column) else {
            return
        }

        gameboardViewController?.gameboard = game.board
        advanceGame()
    }
}
