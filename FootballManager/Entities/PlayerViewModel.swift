//
//  ViewData.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 21.03.2021.
//

import Foundation

struct PlayerViewModel: Hashable {
  var id: UUID
  var playerNumber, playerFullName, playerTeam, playerNationality, playerPosition, playerAge: String
  var playerPhoto: Data?
  var inPlay: Bool
}

