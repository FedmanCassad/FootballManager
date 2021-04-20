//
//  SearchView.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 12.04.2021.
//

import UIKit

class SearchView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var searchByNameTextField: UITextField = {
    var field = UITextField()
    field.placeholder = "Name contains"
    field.borderStyle = .roundedRect
    field.toAutoLayout()
    field.delegate = self
    return field
  }()

  lazy var searchByAgeTextField: UITextField = {
    var field = UITextField()
    field.placeholder = "Age"
    field.borderStyle = .roundedRect
    field.delegate = self
    field.toAutoLayout()
    return field
  }()

  var compareOperatorsSegmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: [">=", "=", "<="])
    control.toAutoLayout()
    control.selectedSegmentIndex = 0
    return control
  }()

  var positionLabel: UILabel = {
    let label = UILabel()
    label.text = "Position:"
    label.toAutoLayout()
    return label
  }()

  var positionSelectButton: UIButton = {
    let button = UIButton()
    button.tag = 0
    button.setTitle("Select", for: .normal)
    button.setTitleColor(.systemTeal, for: .normal)
    button.addTarget(self, action: #selector(revealTeamPickerView(sender:)), for: .touchUpInside)
    button.toAutoLayout()
    return button
  }()

  var teamLabel: UILabel = {
    let label = UILabel()
    label.text = "Team:"
    label.toAutoLayout()
    return label
  }()

  var teamSelectButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.setTitle("Select", for: .normal)
    button.setTitleColor(.systemTeal, for: .normal)
    button.addTarget(self, action: #selector(revealTeamPickerView(sender:)), for: .touchUpInside)
    button.toAutoLayout()
    return button
  }()

  var startSearchButton: UIButton = {
    let button = UIButton()
    button.setTitle("Start search", for: .normal)
    button.setTitleColor(.systemTeal, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 17)
    button.toAutoLayout()
    return button
  }()

  private var resetButton: UIButton = {
    let button = UIButton()
    button.setTitle("Reset", for: .normal)
    button.setTitleColor(.systemTeal, for: .normal)
    button.toAutoLayout()
    return button
  }()

  lazy var selectedPositionLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  lazy var selectedTeamLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  func setupUI() {
    backgroundColor = .white
    [searchByAgeTextField, searchByNameTextField, compareOperatorsSegmentedControl, positionLabel,
     positionSelectButton, teamLabel, teamSelectButton, startSearchButton, resetButton].forEach {
      addSubview($0)
     }
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      searchByNameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      searchByNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      searchByNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      searchByNameTextField.heightAnchor.constraint(equalToConstant: searchByNameTextField.intrinsicContentSize.height),
      searchByAgeTextField.topAnchor.constraint(equalTo: searchByNameTextField.bottomAnchor, constant: 20),
      searchByAgeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      searchByAgeTextField.trailingAnchor.constraint(equalTo: searchByNameTextField.centerXAnchor),
      searchByAgeTextField.heightAnchor.constraint(equalToConstant: searchByAgeTextField.intrinsicContentSize.height),
      compareOperatorsSegmentedControl.leadingAnchor.constraint(equalTo: searchByAgeTextField.trailingAnchor, constant: 10),
      compareOperatorsSegmentedControl.trailingAnchor.constraint(equalTo: searchByNameTextField.trailingAnchor),
      compareOperatorsSegmentedControl.heightAnchor.constraint(equalTo: searchByAgeTextField.heightAnchor),
      compareOperatorsSegmentedControl.centerYAnchor.constraint(equalTo: searchByAgeTextField.centerYAnchor),
      positionLabel.topAnchor.constraint(equalTo: searchByAgeTextField.bottomAnchor, constant: 20),
      positionLabel.leadingAnchor.constraint(equalTo: searchByAgeTextField.leadingAnchor),
      positionLabel.widthAnchor.constraint(equalToConstant: positionLabel.intrinsicContentSize.width),
      positionLabel.heightAnchor.constraint(equalToConstant: positionLabel.intrinsicContentSize.height),
      positionSelectButton.centerYAnchor.constraint(equalTo: positionLabel.centerYAnchor),
      positionSelectButton.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 10),
      positionSelectButton.heightAnchor.constraint(equalTo: positionLabel.heightAnchor),
      positionSelectButton.widthAnchor.constraint(equalToConstant: positionSelectButton.intrinsicContentSize.width),
      teamLabel.leadingAnchor.constraint(equalTo: positionLabel.leadingAnchor),
      teamLabel.topAnchor.constraint(equalTo: positionLabel.bottomAnchor, constant: 30),
      teamLabel.widthAnchor.constraint(equalToConstant: teamLabel.intrinsicContentSize.width),
      teamLabel.heightAnchor.constraint(equalToConstant: teamLabel.intrinsicContentSize.height),
      teamSelectButton.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 10),
      teamSelectButton.centerYAnchor.constraint(equalTo: teamLabel.centerYAnchor),
      teamSelectButton.leadingAnchor.constraint(equalTo: teamLabel.trailingAnchor, constant: 10),
      teamSelectButton.heightAnchor.constraint(equalTo: teamLabel.heightAnchor),
      teamSelectButton.widthAnchor.constraint(equalToConstant: teamSelectButton.intrinsicContentSize.width),
      startSearchButton.widthAnchor.constraint(equalToConstant: startSearchButton.intrinsicContentSize.width),
      startSearchButton.heightAnchor.constraint(equalToConstant: startSearchButton.intrinsicContentSize.height),
      startSearchButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      startSearchButton.topAnchor.constraint(equalTo: bottomAnchor, constant: -400),
      resetButton.widthAnchor.constraint(equalToConstant: resetButton.intrinsicContentSize.width),
      resetButton.heightAnchor.constraint(equalToConstant: resetButton.intrinsicContentSize.height),
      resetButton.centerXAnchor.constraint(equalTo: startSearchButton.centerXAnchor),
      resetButton.topAnchor.constraint(equalTo: startSearchButton.bottomAnchor, constant: 20),
    ])
  }


  @objc private func revealTeamPickerView(sender: UIButton) {
    switch sender.tag {
    case 0:
      dismissPickerViewsFromSuperView()
      let pickerView = UIPickerViewWithToolbar(frame: frame, dataSource: .positionDatasource, targetLabel: selectedPositionLabel)
      pickerView.frame.size.height = 150
      pickerView.frame.origin.y = frame.height * 0.8
      selectedPositionLabel.frame = sender.frame
      sender.removeFromSuperview()
      addSubview(pickerView)
      addSubview(selectedPositionLabel)
      selectedPositionLabel.text = pickerView.pickerView(pickerView.pickerView, titleForRow: 0, forComponent: 0)
      selectedPositionLabel.sizeToFit()
    case 1:
      dismissPickerViewsFromSuperView()
      let pickerView = UIPickerViewWithToolbar(frame: frame, dataSource: .teamDatasource, targetLabel: selectedTeamLabel)
      pickerView.frame.size.height = 150
      pickerView.frame.origin.y = frame.height * 0.8
      selectedTeamLabel.frame = sender.frame
      sender.removeFromSuperview()
      addSubview(pickerView)
      addSubview(selectedTeamLabel)
      selectedTeamLabel.text = pickerView.pickerView(pickerView.pickerView, titleForRow: 0, forComponent: 0)
      selectedPositionLabel.sizeToFit()
    default:
      return
    }
  }

  private func dismissPickerViewsFromSuperView() {
    for view in subviews {
      for view in view.subviews {
        if view is UIPickerView {
          view.superview?.removeFromSuperview()
        }
      }
    }
  }
}

extension SearchView: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }


}
