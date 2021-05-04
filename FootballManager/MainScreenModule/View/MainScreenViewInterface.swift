import UIKit

public enum Filter  {
  case all, inPlay, bench
}

protocol MainScreenViewInterface: RoutableView {
  var presenter: MainScreenPresenterInterface? { get set }
  var filterStatus: Filter { get }
  var diffableDataSource: UITableViewDiffableDataSource<String, PlayerViewModel> { get }
  func initialSetupUI()
  func updateTableView (with items: [PlayerViewModel])
}
