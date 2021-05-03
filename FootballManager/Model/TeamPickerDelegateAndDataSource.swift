//
//  TeamPickerDelegateAndDataSource.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 03.02.2021.
//

import UIKit

final class TeamPickerDelegateAndDataSource: NSObject, PickerViewDelegateAndDataSource {
  typealias Item = String
  private weak var owner: AddPlayerSubview?
  var source: [Item] = ["ЦСКА", "Динамо", "Спартак", "Рубин", "Зенит"]
  
  init(owner: AddPlayerSubview) {
    self.owner = owner
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    source.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    source[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let owner = owner else { return }
    owner.pickedTeam = source[row]
  }
}
