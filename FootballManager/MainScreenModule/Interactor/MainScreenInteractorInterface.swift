import Foundation

protocol InteractorInterface: class {
  var presenter: MainScreenPresenterInterface? { get set }
  func fetchData()
  func fetchData(by fields: [String: Any])
  func deletePlayer(by id: UUID) throws
}
