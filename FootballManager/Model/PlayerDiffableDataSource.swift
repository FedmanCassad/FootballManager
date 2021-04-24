//
//  PlayerDiffableDataSource.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 25.04.2021.
//

import UIKit

class PlayersDiffableDataSource: UITableViewDiffableDataSource<Int, PlayerViewModel>  {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

}
