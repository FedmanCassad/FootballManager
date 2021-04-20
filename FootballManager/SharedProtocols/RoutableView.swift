//
//  RoutableView.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 04.04.2021.
//

import UIKit

protocol RoutableView: class {
  var viewController: RoutableView? { get }
}

extension RoutableView where Self: UIViewController {
  var viewController: RoutableView  {
    return self
  }
}
