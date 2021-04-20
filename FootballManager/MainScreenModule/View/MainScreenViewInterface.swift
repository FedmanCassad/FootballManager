import UIKit

public enum Filter  {
  case all, inPlay, bench
}

protocol MainScreenViewInterface: RoutableView {
  var presenter: MainScreenPresenterInterface? { get set }
  func initialSetupUI()
  var setNeedUpdateData: Bool { get set }
  var filterStatus: Filter { get }
}
