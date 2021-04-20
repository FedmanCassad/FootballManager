import UIKit

protocol RouterInterface {
  var navigationController: UINavigationController? { get set }
  var presenter: MainScreenPresenterInterface? { get set }
  func popBack(animated: Bool)
  func pushController(with viewController: RoutableView)
  func presentController(with viewController: RoutableView)
}

extension RouterInterface {
  func popBack(animated: Bool) {
    navigationController?.popViewController(animated: animated)
  }

  func pushController(with viewController: RoutableView) {
    guard let viewController = viewController as? UIViewController else { return }
    navigationController?.pushViewController(viewController, animated: true)
  }

  func presentController(with viewController: RoutableView)  {
    guard let viewController = viewController as? UIViewController else { return }
    navigationController?.present(viewController, animated: true)
  }
}
