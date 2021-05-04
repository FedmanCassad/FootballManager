//
//  ServiceInterface.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 21.03.2021.
//

import Foundation
import CoreData

protocol MainScreenServiceInterface: class {
  func deletePlayer(by id: UUID) throws
  func fetchData(completionHandler: @escaping (Result<[Player], DataError>) -> ())
  func fetchData(by fields: [String: Any], completionHandler: @escaping (Result<[Player], DataError>) -> ())
  func getSpecificPlayer(by id: UUID) throws -> Player
  func save()
  func getContext() -> NSManagedObjectContext
}

protocol AddPlayerServiceInterface: class {
  func createNSManagedPlayer() -> Player
  func save()
  func getSpecificPlayer(by id: UUID) throws -> Player
}
