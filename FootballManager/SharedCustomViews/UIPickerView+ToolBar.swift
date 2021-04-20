//
//  UIPickerView+ToolBar.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 17.04.2021.
//

import UIKit

// MARK: - Костыльный пикер
public enum PickerViewDatasource {
  case teamDatasource, positionDatasource

  var datasource: [String] {
    switch self {
    case .teamDatasource:
      return ["ЦСКА", "Динамо", "Спартак", "Рубин", "Зенит"]
    case .positionDatasource:
      return ["Вратарь", "Защитник", "Полузащитник", "Нападающий"]
    }
  }
}

class UIPickerViewWithToolbar: UIView {
  var pickerView: UIPickerView!
  var accessoryBar: UIToolbar!
  var datasource: [String]!
  weak var targetLabel: UILabel?

  init(frame: CGRect, dataSource: PickerViewDatasource, targetLabel:  UILabel) {
    super.init(frame: frame)
    pickerView = UIPickerView()
    accessoryBar = UIToolbar()
    pickerView.toAutoLayout()
    accessoryBar.toAutoLayout()
    self.targetLabel = targetLabel
    datasource = dataSource.datasource
    pickerView.delegate = self
    pickerView.dataSource = self
    backgroundColor = .init(white: 0, alpha: 0.1)
    constructView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func constructView() {

    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismiss))
    accessoryBar.items = [space, doneButton]
    addSubview(accessoryBar)
    addSubview(pickerView)
  }

  private func activateConstraints() {
    NSLayoutConstraint.activate([
      accessoryBar.topAnchor.constraint(equalTo: topAnchor),
      accessoryBar.leadingAnchor.constraint(equalTo: leadingAnchor),
      accessoryBar.trailingAnchor.constraint(equalTo: trailingAnchor),
      accessoryBar.heightAnchor.constraint(equalToConstant: 27),
      pickerView.topAnchor.constraint(equalTo: accessoryBar.bottomAnchor),
      pickerView.leadingAnchor.constraint(equalTo: accessoryBar.leadingAnchor),
      pickerView.trailingAnchor.constraint(equalTo: accessoryBar.trailingAnchor),
      pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    activateConstraints()
  }

  @objc func dismiss() {
    removeFromSuperview()
  }
}

// MARK: - PickerViewDelegateAndDatasource

extension UIPickerViewWithToolbar: UIPickerViewDelegate & UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    datasource.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    datasource[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    targetLabel?.text = datasource[row]
    targetLabel?.sizeToFit()
  }

}
