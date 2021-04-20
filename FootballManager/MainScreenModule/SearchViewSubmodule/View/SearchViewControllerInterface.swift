//
//  SearchViewControllerInterface.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 18.04.2021.
//

import Foundation

protocol SearchViewControllerInterface: class {
  func getSearchName() -> String?
  func getSearchAge() -> String?
  func getComparisonSign() -> String?
  func getTeamToSearch() -> String?
  func getPositionToSearch() -> String?
}
