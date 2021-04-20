//
//  PickerViewDelegateAndDataSource.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 03.02.2021.
//

import UIKit

protocol PickerViewDelegateAndDataSource: UIPickerViewDelegate, UIPickerViewDataSource {
  var source: [String] { get set}
}
