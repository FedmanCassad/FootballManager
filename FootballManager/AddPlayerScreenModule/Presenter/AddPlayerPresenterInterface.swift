//
//  AddPlayerPresenterInterface.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 24.03.2021.
//

import Foundation

protocol AddPlayerPresenterInterface: class {
  var interactor: AddPlayerInteractorInterface? { get set }
  var view: AddPlayerViewInterface! { get set }
  var router: AddPlayerRouterInterface? { get set }
  func prepareManagedObjectFromViewModel<T> (of type: T.Type) -> T?
  func needSavePlayer()
  func saveButtonTapped()
  func notifiedViewDidLoad()
}
