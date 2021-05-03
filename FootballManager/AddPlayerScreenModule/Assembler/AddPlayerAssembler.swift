//
//  AddPlayerAssembler.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 26.03.2021.
//

import UIKit

class AddPlayerAssembler: Assembler {
  static func assemblyModule(using navigationController: UINavigationController?) -> RoutableView {
    let router = AddPlayerRouter()
    let presenter = AddPlayerPresenter()
    let interactor = AddPlayerInteractor()
    let view = AddPlayerViewController()
    presenter.interactor = interactor
    presenter.view = view
    presenter.router = router
    router.navigationController = navigationController
    router.presenter = presenter
    interactor.presenter = presenter
    view.presenter = presenter
    return view
  }
}

extension AddPlayerAssembler: EditableViewAssembler {
  static func assemblyModule(using navigationController: UINavigationController?, for editingPlayer: PlayerViewModel?) -> RoutableView {
    let router = AddPlayerRouter()
    let presenter = AddPlayerPresenter()
    let interactor = AddPlayerInteractor()
    let view = AddPlayerViewController(editModeFor: editingPlayer)
    presenter.interactor = interactor
    presenter.view = view
    presenter.router = router
    router.navigationController = navigationController
    router.presenter = presenter
    interactor.presenter = presenter
    view.presenter = presenter
    return view
  }
}
