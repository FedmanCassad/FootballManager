import UIKit
import CoreData

enum FetchType {
  case FRC, CoreDataService
}

class MainScreenInteractor: NSObject, InteractorInterface {

  weak var presenter: MainScreenPresenterInterface?
  private var service: MainScreenServiceInterface?
  var playersFRC: NSFetchedResultsController<Player>!

  override init() {
    self.service = CoreDataService(modelName: "FootballManager")
    super.init()
  }
  
  func fetchData(using fetchingMethod: FetchType) {
    if fetchingMethod == .CoreDataService {
      service?.fetchData {[weak self] result in
        switch result {
        case let .success(payload):
          self?.presenter?.playerDataFetched(with: payload)
        case let .failure(error):
          self?.presenter?.playersDataFetchFailed(with: error)
        }
      }
    } else {
      let request: NSFetchRequest<Player> = NSFetchRequest(entityName: "Player")
      let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
      request.sortDescriptors = [sortDescriptor]
      guard let context = service?.getContext() else { return }
      playersFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      playersFRC.delegate = self
      do {
        try playersFRC.performFetch()
      } catch let error {
        print(error.localizedDescription)
      }
    }
  }
  
  func fetchData(by fields: [String : Any], using fetchingMethod: FetchType) {
    if fetchingMethod == .CoreDataService {
      service?.fetchData(by: fields) {result in
        switch result {
        case let .success(players):
          self.presenter?.playerDataFetched(with: players)
        case let .failure(error):
          self.presenter?.playersDataFetchFailed(with: error)
        }
      }
    } else {
      let request: NSFetchRequest<Player> = NSFetchRequest(entityName: "Player")
      let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
      request.sortDescriptors = [sortDescriptor]
      let constructor = SearchPredicateConstructor()
      let predicates = constructor.getPredicates(by: fields)
      let compoundPredicate: NSCompoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
      request.predicate = compoundPredicate
      guard let context = service?.getContext() else { return }
      playersFRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
      playersFRC.delegate = self
      do {
        try playersFRC.performFetch()
      } catch let error {
        print(error.localizedDescription)
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
    guard let dataSource = presenter?.getTableViewDataSourceReference() else {
      assertionFailure("Data source has not retrieved")
      return
    }
    let snapshot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
    let newSnapshotItems: [PlayerViewModel] = snapshot.itemIdentifiers.compactMap { itemIdentifier in
      guard let existingObject = try? controller.managedObjectContext.existingObject(with: itemIdentifier) as? Player else { return nil }
      let model = presenter?.constructPlayerViewModelFromNSManagedPlayerObject(player: existingObject)

      return model
    }
    var newSnapshot = NSDiffableDataSourceSnapshot<Int, PlayerViewModel>()
    newSnapshot.appendSections([0])
    newSnapshot.appendItems(newSnapshotItems)
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }

}
