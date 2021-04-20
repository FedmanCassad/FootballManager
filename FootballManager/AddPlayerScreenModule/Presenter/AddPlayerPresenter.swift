//
//  AddPlayerPresenter.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 26.03.2021.
//

import Foundation

class AddPlayerPresenter: NSObject, AddPlayerPresenterInterface {
  var router: AddPlayerRouterInterface?
  weak var view: AddPlayerViewInterface!
  var interactor: AddPlayerInteractorInterface?
  
  func notifiedViewDidLoad() {
    view.initialSetupUI()
  }
  
  func saveButtonTapped() {
    needSavePlayer()
  }
  
  func prepareManagedObjectFromViewModel<T>(of type: T.Type) -> T? {
    guard let player = interactor?.getManagedObject(of: type.self) else { return nil }
    return player
  }
  
  func needSavePlayer() {
    let player = prepareManagedObjectFromViewModel(of: Player.self)
    player?.id = UUID()
    player?.number = view.getPlayerNumber().safeInt16()
    player?.image = view.getPlayerPhoto()
    player?.fullName = view.getPlayerName()
    player?.nationality = view.getPlayerNationality()
    player?.age = view.getPlayerAge().safeInt16()
    player?.team = view.getPlayerTeam()
    player?.position = view.getPlayerPosition()
    player?.inPlay = view.getStatus()
    interactor?.saveChanges()
    router?.rollBack(animated: true)
  }
}
