//
//  AddPlayerScreenInteractorInterface.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 24.03.2021.
//

import Foundation

protocol AddPlayerInteractorInterface {
  var presenter: AddPlayerPresenterInterface? { get set }
  func getManagedObject<T> (of type: T.Type) -> T?
  func saveChanges()
}
