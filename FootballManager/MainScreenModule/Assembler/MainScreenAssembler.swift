//
//  MainScreenAssembler.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 21.03.2021.
//

import UIKit

final class MainScreenAssembler: Assembler {
  static func assemblyModule(using navigationController: UINavigationController? ) -> RoutableView {
    let router = MainScreenRouter()
    let presenter = MainScreenPresenter()
    let interactor = MainScreenInteractor()
    let view = MainViewController()
    presenter.interactor = interactor
    presenter.view = view
    presenter.router = router
    router.navigationController = navigationController
    router.presenter = presenter
    interactor.presenter = presenter
    view.presenter = presenter
    navigationController?.viewControllers = [view as UIViewController]
    return view
  }
}
