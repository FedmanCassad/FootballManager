//
//  PlayerViewController.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 22.01.2021.
//

import UIKit

class AddPlayerViewController: UIViewController {
  var presenter: AddPlayerPresenterInterface?
  private var addPlayerView: AddPlayerSubview = Bundle.main.loadNibNamed("AddPlayerSubview", owner: self, options: nil)?.first as! AddPlayerSubview
  private var segmentedControl: UISegmentedControl = .instantiatePlayersFilterSC(type: .compact)
  private var imagePicker: UIImagePickerController = .init()
  var editablePlayerID: UUID?
  var isEditMode: Bool {
    editablePlayerID != nil
  }

  convenience init(editModeFor player: PlayerViewModel?) {
    self.init()
    guard let player = player else { return }
    addPlayerView.ageTextField.text = player.playerAge
    addPlayerView.playerNumberTextField.text = player.playerNumber
    addPlayerView.playerPhotoImageView.image = UIImage(data: player.playerPhoto!)
    addPlayerView.pickedTeam = player.playerTeam
    addPlayerView.pickedPosition = player.playerPosition
    addPlayerView.nameTextField.text = player.playerFullName
    addPlayerView.nationalityTextField.text = player.playerNationality
    segmentedControl.selectedSegmentIndex = player.inPlay ? 0 : 1
    editablePlayerID = player.id
    addPlayerView.checkTextFieldsToDoNotBeingEmpty()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.notifiedViewDidLoad()
    addPlayerView.saveButton.addTarget(self, action: #selector(saveToCoreData), for: .touchUpInside)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        segmentedControl.heightAnchor.constraint(equalToConstant: 30),
        addPlayerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
        addPlayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        addPlayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        addPlayerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }

  private func setupUI() {
    overrideUserInterfaceStyle = .light
    addPlayerView.toAutoLayout()
    view.addSubview(segmentedControl)
    view.addSubview(addPlayerView)
    addPlayerView.uploadImageButton.addTarget(self, action: #selector(addImagePicker), for: .touchUpInside)
    setupTextFieldsDelegate()
    let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    addPlayerView.addGestureRecognizer(dismissGesture)
  }
  
  func initialSetupUI() {
    setupUI()
    setupConstraints()
  }
  
  private func setupTextFieldsDelegate() {
    for case let view in addPlayerView.subviews where view is UITextField  {
      let textField = view as! UITextField
      textField.delegate = self
    }
  }
}

// MARK: - Save to CoreData service
extension AddPlayerViewController {
  @objc private func saveToCoreData() {
    presenter?.saveButtonTapped()
  }
}

//MARK: - At this point I wanna add UIImagePicker
extension AddPlayerViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  @objc private func addImagePicker() {
    imagePicker.delegate = self
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    imagePicker.mediaTypes = ["public.image"]
    present(imagePicker, animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true)
    if let image = info[.editedImage] as? UIImage {
      addPlayerView.playerPhotoImageView.image = image
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

//MARK: - Hiding keyboard

extension AddPlayerViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField.tag {
    case 0:
      addPlayerView.nameTextField.becomeFirstResponder()
    case 1:
      addPlayerView.nationalityTextField.becomeFirstResponder()
    case 2:
      addPlayerView.ageTextField.becomeFirstResponder()
    case 3:
      view.endEditing(true)
    default:
      view.endEditing(true)
    }
    return true
  }
  
  // MARK: - Ограничиваем ввод
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField.tag == 0 || textField.tag == 3 {
      let currentText = textField.text ?? ""
      guard let stringRange = Range(range, in: currentText) else { return false }
      let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
      if updatedText.count <= 2 {
        return isEnteredCharacterIsDigit(text: updatedText)
      }
    } else {
      return true
    }
    return false
  }
  
  private func isEnteredCharacterIsDigit(text: String) -> Bool {
    let allowedCharacterSet = CharacterSet.decimalDigits
    let currentCharacterSet = CharacterSet(charactersIn: text)
    return allowedCharacterSet.isSuperset(of: currentCharacterSet)
  }
}

extension AddPlayerViewController {
  @objc private func dismissKeyboard() {
    addPlayerView.endEditing(true)
  }
}

extension AddPlayerViewController: AddPlayerViewInterface {
  var viewController: RoutableView? {
    self
  }
  
  func getStatus() -> Bool {
    segmentedControl.selectedSegmentIndex == 0 ? true : false
  }

  func getPlayerNumber() -> String? {
    addPlayerView.playerNumberTextField.text
  }
  
  func getPlayerPhoto() -> Data? {
    addPlayerView.playerPhotoImageView.image?.pngData()
  }
  
  func getPlayerName() -> String? {
    addPlayerView.nameTextField.text
  }
  
  func getPlayerNationality() -> String? {
    addPlayerView.nationalityTextField.text
  }
  
  func getPlayerAge() -> String? {
    addPlayerView.ageTextField.text
  }
  
  func getPlayerTeam() -> String? {
    addPlayerView.pickedTeam
  }
  
  func getPlayerPosition() -> String? {
    addPlayerView.pickedPosition
  }
}
