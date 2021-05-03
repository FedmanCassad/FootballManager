//
//  AddPlayerInteractor.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 26.03.2021.
//

import Foundation

class AddPlayerInteractor: NSObject, AddPlayerInteractorInterface {


  weak var presenter: AddPlayerPresenterInterface?
  private var service: AddPlayerServiceInterface?
  
  override init() {
    self.service = CoreDataService(modelName: "FootballManager")
  }

  func getManagedObject<T>(of type: T.Type) -> T?  {
    let player: Player? = service?.createNSManagedPlayer()
    return player as? T
  }
  
  func saveChanges() {
    service?.save()
  }

  func getEditablePlayer(by id: UUID) throws -> Player? {
    guard let player: Player = try? service?.getSpecificPlayer(by: id) else { return nil }
    return player
  }
}
