//
//  ViewController.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 21.01.2021.
//

import UIKit

class MainViewController: UIViewController {
  var presenter: MainScreenPresenterInterface?
  var tableView: UITableView!
  var segmentControl: UISegmentedControl!

  lazy var diffableDataSource: UITableViewDiffableDataSource<Int, PlayerViewModel> = {
    let dataSource = PlayersDiffableDataSource(tableView: tableView) {tableView, indexPath, item in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerCell else {
        return UITableViewCell()
      }
    cell.configure(with: item)
    return cell
  }
    dataSource.defaultRowAnimation = .left
    return dataSource
  }()

  var filterStatus: Filter {
    switch segmentControl.selectedSegmentIndex {
    case 0:
      return .all
    case 1:
      return .inPlay
    case 2:
      return .bench
    default:
      return .all
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    overrideUserInterfaceStyle = .light
    presenter?.notifiedViewDidLoad()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presenter?.notifiedViewWillAppear()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: view.bounds)
    tableView.register(UINib(nibName: "PlayerCell", bundle: nil), forCellReuseIdentifier: "playerCell")
    tableView.dataSource = diffableDataSource
    tableView.toAutoLayout()
    tableView.delegate = self
    tableView.allowsSelection = false
  }
  
  private func setupSegmentedControl() {
    segmentControl = .instantiatePlayersFilterSC(type: .full)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate(
      [
        segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        segmentControl.heightAnchor.constraint(equalToConstant: 30),
        tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ]
    )
  }
  
  private func setupUI() {
    overrideUserInterfaceStyle = .light
    view.addSubview(segmentControl)
    view.addSubview(tableView)
    setupConstraints()
    tableView.backgroundColor = .white
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddPlayerController))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchButtonTapped))
    segmentControl.addTarget(self, action: #selector(predicateSelected(sender:)), for: .valueChanged)
  }
}

// MARK: - MainScreenViewInterface and Routable protocols adoption
extension MainViewController: MainScreenViewInterface, RoutableView {
  func updateTableView(with items: [PlayerViewModel]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, PlayerViewModel>()
    snapshot.appendSections([0])
    snapshot.appendItems(items, toSection: 0)
    diffableDataSource.apply(snapshot, animatingDifferences: true)
  }

  
  var viewController: RoutableView? {
    return self
  }

  func initialSetupUI() {
    setupSegmentedControl()
    setupTableView()
    setupUI()
  }

  
}

// MARK: - UITableViewDataSource essential method realization
extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {[weak self] _, view, isPerformed in
      view.backgroundColor = .red
      self?.presenter?.playerDeleted(at: indexPath.row)
      self?.presenter?.tableViewNeedsUpdate()
      isPerformed(true)
    }
    let player = presenter?.playerViewModels[indexPath.row]
    let editAction = UIContextualAction(style: .normal, title: "Edit") {[weak self] _, view, isPerformed in
      self?.presenter?.notifyWantsEditPlayerCard(with: player)
      isPerformed(true)
    }
    editAction.backgroundColor = .orange
    let playerStatus = presenter?.getPlayerViewModel(at: indexPath.row)?.inPlay ?? true
    let changeStatusAction = UIContextualAction(style: .normal, title: playerStatus ? "On bench" : "In play") {[weak self] _, view, isPerformed in
      guard let playerID = self?.presenter?.getPlayerViewModel(at: indexPath.row)?.id else { return }
      self?.presenter?.notifyWantChangePlayerStatus(byPlayerId: playerID, isInPlay: playerStatus ? false : true)
      self?.presenter?.notifiedViewWillAppear()
      tableView.reloadRows(at: [indexPath], with: .automatic)
      isPerformed(true)
      
    }
    changeStatusAction.backgroundColor = .purple
    let swipeActionConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, changeStatusAction])
    return swipeActionConfiguration
  }
}

// MARK: - Action for add barButtonItem
extension MainViewController {
  @objc private func showAddPlayerController() {
    presenter?.addPlayerButtonTapped()
  }
}

// MARK: - Action for segmentedControl
extension MainViewController {
  @objc private func predicateSelected(sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case 0:
      presenter?.filterChanged(with: .all)
    case 1:
      presenter?.filterChanged(with: .inPlay)
    case 2:
      presenter?.filterChanged(with: .bench)
    default:
      presenter?.filterChanged(with: .all)
    }
  }
  
  @objc func searchButtonTapped() {
    presenter?.searchButtonTapped()
  }
}
