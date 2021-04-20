//
//  AddPlayerScreenRouter.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 24.03.2021.
//

import UIKit

protocol AddPlayerRouterInterface: class {
  var presenter: AddPlayerPresenterInterface? { get set }
  var navigationController: UINavigationController? { get set }
  func rollBack(animated: Bool)
  func push(viewController: UIViewController, animated: Bool)
  func dismiss(animated: Bool)
}
