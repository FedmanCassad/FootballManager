//
//  Assembler.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 28.03.2021.
//

import UIKit

protocol Assembler {
  static func assemblyModule(using navigationController: UINavigationController ) -> RoutableView
}
