//
//  AddPlayerScreenViewInterface.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 24.03.2021.
//

import UIKit

protocol AddPlayerViewInterface: RoutableView {
  var presenter: AddPlayerPresenterInterface? { get set }
  var editablePlayerID: UUID? { get }
  var isEditMode: Bool { get }
  func initialSetupUI()
  func getPlayerNumber() -> String?
  func getPlayerPhoto() -> Data?
  func getPlayerName() -> String?
  func getPlayerNationality() -> String?
  func getPlayerAge() -> String?
  func getPlayerTeam() -> String?
  func getPlayerPosition() -> String?
  func getStatus() -> Bool
}

