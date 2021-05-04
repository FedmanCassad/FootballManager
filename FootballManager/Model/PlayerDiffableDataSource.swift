//
//  PlayerDiffableDataSource.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 25.04.2021.
//

import UIKit

class PlayersDiffableDataSource: UITableViewDiffableDataSource<String, PlayerViewModel>  {
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    self.snapshot().sectionIdentifiers[section]
  }

}
