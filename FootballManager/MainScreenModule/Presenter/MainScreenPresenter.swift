
import CoreData

class MainScreenPresenter: NSObject, MainScreenPresenterInterface {

  func tableViewNeedsUpdate() {
    view?.updateTableView(with: playerViewModels)
  }

  var playerViewModels: [PlayerViewModel]!
  weak var view: MainScreenViewInterface?
  var router: RouterInterface?
  var interactor: InteractorInterface?
  weak var searchView: SearchViewControllerInterface?
  var filterDictionary: [String: Any] {
    var dict = [String: Any]()
    switch view?.filterStatus {
    case .all:
      return dict
    case .bench:
      dict["inPlay"] = false
      return dict
    case .inPlay:
      dict["inPlay"] = true
      return dict
    case .none:
      return dict
    }
  }
  
  // MARK: - View lifecycle
  func notifiedViewDidLoad() {
    view?.initialSetupUI()
  }
  
  func notifiedViewWillAppear() {
    self.getListOfPlayers()
  }
  
  func addPlayerButtonTapped() {
    let addVC = AddPlayerAssembler.assemblyModule(using: (router?.navigationController)!)
    router?.pushController(with: addVC)
  }
  
  func searchButtonTapped() {
    let searchVC = SearchSubmoduleAssembler.assemblySubmodule(for: self)
    self.searchView = searchVC as? SearchViewControllerInterface
    router?.presentController(with: searchVC)
  }
  
  func getPlayerViewModel(at index: Int) -> PlayerViewModel? {
    playerViewModels?[index]
  }
  
  func playerDeleted(at index: Int) {
    defer {
      playerViewModels?.remove(at: index)
    }
    do {
      try interactor?.deletePlayer(by: (playerViewModels?[index].id)!)
    } catch let error {
      print(error.localizedDescription)
    }
  }
  
  private func getListOfPlayers() {
    interactor?.fetchData()
  }
  
  func playerDataFetched(with payload: [Player]) {
    var temporaryViewModelsArray = [PlayerViewModel]()
    for player in payload {
      let viewModel: PlayerViewModel = self.constructPlayerViewModelFromNSManagedPlayerObject(player: player)
      temporaryViewModelsArray.append(viewModel)
    }
    self.playerViewModels = temporaryViewModelsArray
    view?.updateTableView(with: self.playerViewModels)
  }
  
  func playersDataFetchFailed(with error: DataError) {
    print(error.localizedDescription)
  }
  
  func filterChanged(with: Filter) {
    switch with {
    case .all:
      interactor?.fetchData()
    case .inPlay:
      interactor?.fetchData(by: ["inPlay": true])
    case .bench:
      interactor?.fetchData(by: ["inPlay": false])
    }
  }
  
  private func constructPlayerViewModelFromNSManagedPlayerObject(player: Player) -> PlayerViewModel {
    let playerNumber = String(player.number),
        playerAge = String(player.age),
        playerFullName = player.fullName ?? "Noname",
        playerTeam = player.team ?? "Not in team",
        playerNationality = player.nationality ?? "Nationality undefined",
        playerPosition = player.position ?? "No position defined",
        playerID = player.id ?? UUID()
    var playerImageData: Data? = nil
    if let data = player.image {
      playerImageData = data
    }
    let playerStatus = player.inPlay
    let viewModel = PlayerViewModel(id: playerID,
                                    playerNumber: playerNumber,
                                    playerFullName: playerFullName,
                                    playerTeam: playerTeam,
                                    playerNationality: playerNationality,
                                    playerPosition: playerPosition,
                                    playerAge: playerAge,
                                    playerPhoto: playerImageData,
                                    inPlay: playerStatus)
    
    return viewModel
  }
}

extension MainScreenPresenter: SearchViewControllerHandler {
  func startSearchButtonPressed() {
    var searchDict = filterDictionary
    if let name = searchView?.getSearchName() {
      searchDict["fullName"] = name
    }
    if let age = searchView?.getSearchAge() {
      searchDict["age"] = age
    }
    if let comparisonSign = searchView?.getComparisonSign() {
      searchDict["comparisonSign"] = comparisonSign
    }
    if let position = searchView?.getPositionToSearch() {
      searchDict["position"] = position
    }
    if let team = searchView?.getTeamToSearch() {
      searchDict["team"] = team
    }
    interactor?.fetchData(by: searchDict)
  }
}
