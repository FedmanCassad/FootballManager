import Foundation

protocol InteractorInterface: class {
  var presenter: MainScreenPresenterInterface? { get set }
  func fetchData(using fetchingMethod: FetchType)
  func fetchData(by fields: [String: Any], using fetchingMethod: FetchType)
  func deletePlayer(by id: UUID) throws
  func getEditablePlayer(by id: UUID) -> Player?
  func updatePlayerStatus(by id: UUID, isInPlay: Bool)
}
