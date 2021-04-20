//
//  SegmentControlWithoutCornetRadius.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 11.04.2021.
//

import UIKit

// Сегмент контрол без скругления фоновой фьюхи.
class SegmentedControlWithoutCornerRadius: UISegmentedControl {
  override func layoutSubviews() {
          super.layoutSubviews()
          layer.cornerRadius = 0
      }
}
