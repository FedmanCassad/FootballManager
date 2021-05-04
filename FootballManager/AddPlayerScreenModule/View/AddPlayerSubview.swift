//
//  swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 24.01.2021.
//

import UIKit

final class AddPlayerSubview: UIView {
  @IBOutlet weak var playerNumberTextField: UITextField!
  @IBOutlet weak var playerPhotoImageView: UIImageView!
  @IBOutlet weak var uploadImageButton: UIButton!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var nationalityTextField: UITextField!
  @IBOutlet weak var ageTextField: UITextField!
  @IBOutlet weak var chooseTeamButton: UIButton!
  @IBOutlet weak var choosePositionButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  var pickedPosition: String? {
    willSet {
      choosePositionButton.setTitle(newValue, for: .normal)
    }
  }
  var pickedTeam: String? {
    willSet {
      chooseTeamButton.setTitle(newValue, for: .normal)
    }
  }
  private var teamDataSource: TeamPickerDelegateAndDataSource!
  private var positionDataSource: PositionPickerDelegateAndDataSource!
  
  lazy var chosenTeamLabel: UILabel =  {
    let label = UILabel()
    label.textAlignment = .center
    label.text = ""
    return label
  }()
  
  lazy var chosenPositionLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.text = ""
    return label
  }()
  
  var anyTextFieldIsEmpty: Bool {
    guard let numberText = playerNumberTextField.text,
          let ageText = ageTextField.text,
          let nameText = nameTextField.text,
          let nationalityText = nationalityTextField.text
    else {
      return true
    }
    return numberText.isEmpty || ageText.isEmpty || nameText.isEmpty || nationalityText.isEmpty || pickedPosition == nil || pickedTeam == nil
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    teamDataSource = TeamPickerDelegateAndDataSource(owner: self)
    positionDataSource = PositionPickerDelegateAndDataSource(owner: self)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    addTextfieldCheckingForBeingEmpty()
    addTeamPickerView()
    setupKeyboardForTextFields()
  }
  
  func alignLabels() {
    chosenPositionLabel.center.x = chosenTeamLabel.center.x
  }
  
  private func setupKeyboardForTextFields() {
    playerNumberTextField.returnKeyType = .next
  }
}

//MARK: - Checking for text field to not being empty
extension AddPlayerSubview {
  @objc func checkTextFieldsToDoNotBeingEmpty() {
    saveButton.isEnabled = !anyTextFieldIsEmpty
  }
  
  private func addTextfieldCheckingForBeingEmpty() {
    subviews.forEach {
      if $0 is UITextField {
        let field = $0 as! UITextField
        field.addTarget(self, action: #selector(checkTextFieldsToDoNotBeingEmpty), for: .editingChanged)
      }
    }
  }
}

//MARK: Здесь я настраиваю пикерВьюшки. Возможно это не самое удачное решение, но вот в рамках своего разумения я решил, что делать делегатом и источником данных для пикеров все этот же вью контроллер как то не очень правильно.

extension AddPlayerSubview {
  private func addTeamPickerView() {
    chooseTeamButton.addTarget(self, action: #selector(revealTeamPickerView(sender:)), for: .touchUpInside)
    choosePositionButton.addTarget(self, action: #selector(revealTeamPickerView(sender:)), for: .touchUpInside)
  }
  
  @objc private func revealTeamPickerView(sender: UIButton) {
    //TODO Думаю это тоже надо перенести в презентер. Хотя это все логика чисто вьюшная, внешка. Вроде как и незачем перезентер этим шлаком засирать.
    let picker = UIPickerView()
    switch sender.tag {
    case 0:
      setUpPickerView (picker: picker, delegateAndDataSource: teamDataSource)
      pickedTeam = teamDataSource.source[picker.selectedRow(inComponent: 0)]
      chosenTeamLabel.text = teamDataSource.source[picker.selectedRow(inComponent: 0)]
    case 1:
      setUpPickerView (picker: picker, delegateAndDataSource: positionDataSource)
      pickedPosition = positionDataSource.source[picker.selectedRow(inComponent: 0)]
      chosenPositionLabel.text = positionDataSource.source[picker.selectedRow(inComponent: 0)]
    default:
      return
    }
  }
  
  
  private func setUpPickerView (picker: UIPickerView, delegateAndDataSource: PickerViewDelegateAndDataSource) {
    var pickerContentView = UIView()
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPickerViewsFromSuperView(sender:)))
    let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    pickerContentView = UIView(frame: CGRect(x: 0, y: frame.height - frame.height * 0.2, width: frame.width, height: frame.height * 0.2))
    let accessoryBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 30))
    accessoryBar.layoutMargins = .zero
    accessoryBar.compactAppearance = .init(idiom: .phone)
    picker.frame.size.width = UIScreen.main.bounds.width
    picker.frame.size.height = pickerContentView.frame.height - accessoryBar.frame.height
    picker.frame.origin = CGPoint(x: 0, y: accessoryBar.frame.height)
    pickerContentView.backgroundColor = .white
    picker.backgroundColor = .white
    accessoryBar.barStyle = .default
    accessoryBar.isTranslucent = false
    accessoryBar.items = [space, doneButton]
    picker.delegate = delegateAndDataSource
    picker.dataSource = delegateAndDataSource
    pickerContentView.addSubview(accessoryBar)
    pickerContentView.addSubview(picker)
    addSubview(pickerContentView)
    endEditing(true)
  }
  
  private func addPickerResultingLabels(label: UILabel, at: UIView) {
    label.frame = at.frame
    addSubview(label)
  }
  //TODO Перенести в презентер
  @objc func dismissPickerViewsFromSuperView(sender: UIBarButtonItem) {
    for view in subviews {
      for view in view.subviews {
        if view is UIPickerView {
          view.superview?.removeFromSuperview()
        }
      }
    }
    checkTextFieldsToDoNotBeingEmpty()
  }
}

// MARK: - Smooth updating button sizes depending on content width
extension AddPlayerSubview {
  func updateButtonsWidth(button: UIButton, oldWidth: CGFloat, newWidth: CGFloat) {
    let diff = newWidth - oldWidth
    button.frame.size.width += diff
  }
}
