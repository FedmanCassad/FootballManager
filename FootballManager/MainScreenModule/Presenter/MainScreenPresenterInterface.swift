import UIKit

protocol MainScreenPresenterInterface: class {
  var view: MainScreenViewInterface? { get set }
  var router: RouterInterface? { get set }
  var interactor: InteractorInterface? { get set }
  var playerViewModels: [PlayerViewModel]! { get set }
  func getPlayerViewModel(at index: Int) -> PlayerViewModel?
  func addPlayerButtonTapped()
  func searchButtonTapped()
  func playerDataFetched(with payload: [Player])
  func playersDataFetchFailed(with error: DataError)
  func playerDeleted(at index: Int)
  func notifiedViewDidLoad()
  func notifiedViewWillAppear()
  func filterChanged(with: Filter)
  func tableViewNeedsUpdate()
  func notifyWantsEditPlayerCard(with player: PlayerViewModel?)
  func notifyWantChangePlayerStatus(byPlayerId id: UUID, isInPlay: Bool)
}

protocol MainScreenFRCEssentialsInterface {
  func getTableViewDataSourceReference() -> UITableViewDiffableDataSource<Int, PlayerViewModel>
}
