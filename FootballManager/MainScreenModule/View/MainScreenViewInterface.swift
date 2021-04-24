import UIKit

public enum Filter  {
  case all, inPlay, bench
}

protocol MainScreenViewInterface: RoutableView {
  var presenter: MainScreenPresenterInterface? { get set }
  func initialSetupUI()
  func updateTableView (with items: [PlayerViewModel])
  var filterStatus: Filter { get }

}
