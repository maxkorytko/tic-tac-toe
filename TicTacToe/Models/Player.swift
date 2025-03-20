//
//  Player.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-20.
//

import Foundation

enum Player: Hashable {
    case o(PlayerProfile)
    case x(PlayerProfile)

    var profile: PlayerProfile {
        switch self {
        case let .o(profile):
            return profile
        case let .x(profile):
            return profile
        }
    }
}

struct PlayerProfile: Hashable {
    let name: String
}
