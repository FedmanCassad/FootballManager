import UIKit
import CoreData

class MainScreenInteractor: NSObject, InteractorInterface {

  weak var presenter: MainScreenPresenterInterface?
  private var service: MainScreenServiceInterface?
  var playersFRC = NSFetchedResultsController<Player>()

  override init() {
    self.service = CoreDataService(modelName: "FootballManager")
    super.init()
    self.playersFRC.delegate = self
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

  func getEditablePlayer(by id: UUID) -> Player? {
    guard let player = try? service?.getSpecificPlayer(by: id) else { return nil}
    return player
  }

  func updatePlayerStatus(by id: UUID, isInPlay: Bool) {
    let player = getEditablePlayer(by: id)
    player?.inPlay = isInPlay
    service?.save()
    presenter?.tableViewNeedsUpdate()
  }
}

extension MainScreenInteractor: NSFetchedResultsControllerDelegate {
   func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {

  }
}
