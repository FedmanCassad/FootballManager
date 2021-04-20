//
//  AddPlayerInteractor.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 26.03.2021.
//

import Foundation

class AddPlayerInteractor: NSObject, AddPlayerInteractorInterface {
  weak var presenter: AddPlayerPresenterInterface?
  private var service: CoreDataService?
  
  override init() {
    self.service = CoreDataService(modelName: "FootballManager")
  }
  
  func getManagedObject<T>(of type: T.Type) -> T?  {
    return service?.createObject(from: type)
  }
  
  func saveChanges() {
    service?.save()
  }
}
