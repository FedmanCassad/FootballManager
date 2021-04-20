//
//  SearchViewController.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 15.04.2021.
//

import UIKit

class SearchViewController: UIViewController, RoutableView {
  var viewController: RoutableView?
  weak var masterPresenter: SearchViewControllerHandler?

  init(parentPresenter: SearchViewControllerHandler) {
    super.init(nibName: nil, bundle: nil)
    masterPresenter = parentPresenter
    view = SearchView(frame: view.frame)
    if let view  = view as? SearchView {
      view.startSearchButton.addTarget(self, action: #selector(startSearchButtonTapped), for: .touchUpInside)
      view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    overrideUserInterfaceStyle = .light
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc func startSearchButtonTapped() {
    masterPresenter?.startSearchButtonPressed()
    dismiss(animated: true)
  }
}

extension SearchViewController: SearchViewControllerInterface {
  func getSearchName() -> String? {
    guard let view = view as? SearchView,
          let name = view.searchByNameTextField.text else { return nil}
    if name.isEmpty {
      return nil
    }
    return name
  }

  func getSearchAge() -> String? {
    guard let view = view as? SearchView,
          let age = view.searchByAgeTextField.text else { return nil}
    if age.isEmpty {
      return nil
    }
    return age
  }

  func getComparisonSign() -> String? {
    guard let view = view as? SearchView else { return nil}
    let selectedIndex = view.compareOperatorsSegmentedControl.selectedSegmentIndex
    let sign = view.compareOperatorsSegmentedControl.titleForSegment(at: selectedIndex)
    return sign
  }

  func getTeamToSearch() -> String? {
    guard let view = view as? SearchView,
          let team = view.selectedTeamLabel.text else { return nil}
    if team.isEmpty {
      return nil
    }
    return team
  }

  func getPositionToSearch() -> String? {
    guard let view = view as? SearchView,
          let position = view.selectedPositionLabel.text else { return nil}
    if position.isEmpty {
      return nil
    }
    return position
  }

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

}
