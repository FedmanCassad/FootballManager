//
//  PositionPickerDelegateAndDataSource.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 03.02.2021.
//

import UIKit

final class PositionPickerDelegateAndDataSource: NSObject, PickerViewDelegateAndDataSource {
  typealias Item = String
  var source: [Item] = ["Вратарь", "Защитник", "Полузащитник", "Нападающий"]
  let owner: AddPlayerSubview
  
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
    owner.chosenPositionLabel.text = source[row]
    owner.chosenPositionLabel.frame.size.width = owner.chosenPositionLabel.intrinsicContentSize.width
    owner.alignLabels()
    owner.pickedPosition = source[row]
  }
}
