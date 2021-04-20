import Foundation

class MainScreenInteractor: NSObject, InteractorInterface {
  weak var presenter: MainScreenPresenterInterface?
  private var service: MainScreenServiceInterface?
  
  override init() {
    self.service = CoreDataService(modelName: "FootballManager")
  }
  
  func fetchData() {
    service?.fetchData {[weak self] result in
      switch result {
      case let .success(payload):
        self?.presenter?.playerDataFetched(with: payload)
      case let .failure(error):
        self?.presenter?.playersDataFetchFailed(with: error)
      }
    }
  }
  
  func fetchData(by fields: [String : Any]) {
    service?.fetchData(by: fields) {result in
      switch result {
      case let .success(players):
        self.presenter?.playerDataFetched(with: players)
      case let .failure(error):
        self.presenter?.playersDataFetchFailed(with: error)
      }
    }
  }
  
  func deletePlayer(by id: UUID) throws {
    try service?.deletePlayer(by: id)
  }
}
