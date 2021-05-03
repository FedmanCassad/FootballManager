//
//  AddPlayerRouter.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 26.03.2021.
//

import UIKit

class AddPlayerRouter: AddPlayerRouterInterface {
  weak var navigationController: UINavigationController?
  weak var presenter: AddPlayerPresenterInterface?

  func rollBack(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }

  func push(viewController: UIViewController, animated: Bool) {
    navigationController?.pushViewController(viewController, animated: animated)
  }
  
  func dismiss(animated: Bool) {
    navigationController?.dismiss(animated: true)
  }
}
