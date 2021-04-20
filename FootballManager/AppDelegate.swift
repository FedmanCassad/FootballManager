//
//  AppDelegate.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 21.01.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    prepareAndShowWindow()
    return true
  }
  
  private func prepareAndShowWindow() {
    window = UIWindow()
    let navigationController = UINavigationController()
    navigationController.navigationBar.backgroundColor = .white
    _ = MainScreenAssembler.assemblyModule(using: navigationController)
    navigationController.overrideUserInterfaceStyle = .light
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
}
