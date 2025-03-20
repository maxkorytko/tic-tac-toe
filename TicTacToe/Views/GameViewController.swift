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

    private var gameboardViewController: GameboardViewController?

    fileprivate let game: Game = Game(
        player1: .x(PlayerProfile(name: "Player 1")),
        player2: .o(PlayerProfile(name: "Player 2"))
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender: Any?
    ) {
        if let gameboardViewController = segue.destination as? GameboardViewController {
            self.gameboardViewController = gameboardViewController
            gameboardViewController.delegate = self
            gameboardViewController.gameboard = game.board
        }
    }

    private func advanceGame() {
        game.checkWinner { [weak self] winner in
            if let winner = winner {
                self?.show(winner)
            } else {
                self?.game.advance()
            }
        }
    }

    private func show(_ winner: Player) {
        print("Winner is \(winner.profile.name)")
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
