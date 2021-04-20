//
//  PlayerCell.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 23.01.2021.
//

import UIKit
import CoreData

final class PlayerCell: UITableViewCell {
  @IBOutlet weak var playerNumberLabel: UILabel!
  @IBOutlet weak var playerFullNameLabel: UILabel!
  @IBOutlet weak var playerPhotoImageView: UIImageView!
  @IBOutlet weak var playerTeamLabel: UILabel!
  @IBOutlet weak var playerNationalityLabel: UILabel!
  @IBOutlet weak var playerPositionLabel: UILabel!
  @IBOutlet weak var playerAgeLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  func configure(with player: PlayerViewModel?)
  {
    guard let player = player else { return }
    if let photoData = player.playerPhoto {
      playerPhotoImageView.image = UIImage(data: photoData)
    }
    playerNumberLabel.text = player.playerNumber
    playerFullNameLabel.text = player.playerFullName
    playerTeamLabel.text = player.playerTeam
    playerNationalityLabel.text = player.playerNationality
    playerPositionLabel.text = player.playerPosition
    playerAgeLabel.text = player.playerAge
    statusLabel.text = player.inPlay ? "In play" : "Bench"
  }
}
