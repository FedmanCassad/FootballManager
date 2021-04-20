//
//  SearchSubmoduleAssembler.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 18.04.2021.
//

import UIKit

class SearchSubmoduleAssembler {
  static func assemblySubmodule(for masterPresenter: MainScreenPresenterInterface) -> RoutableView {
    let vc = SearchViewController(parentPresenter: masterPresenter as! SearchViewControllerHandler)
    return vc
  }
}
