//
//  UIVIewController + FilterPlayersSegmentedControlGenerator.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 11.04.2021.
//

import UIKit

extension UISegmentedControl {
  enum PlayersFilterType {
    case  full, compact
  }
  
  static func instantiatePlayersFilterSC(type: PlayersFilterType) -> UISegmentedControl {
    let control = SegmentedControlWithoutCornerRadius(items: ["All", "In play", "Bench"])
    if type == .compact {
      control.removeSegment(at: 0, animated: false)
    }
    control.backgroundColor = .white
    control.selectedSegmentIndex = 0
    control.toAutoLayout()
    return control
  }
}
