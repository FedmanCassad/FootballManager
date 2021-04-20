//
//  DataErrors.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 25.03.2021.
//

import Foundation

enum DataError: Error, LocalizedError {
  case fetchError
  case errorDeletingPlayer
  var errorDescription: String? {
    switch self {
      case .fetchError:
        return "Error fetching request to CoreData storage:\(type(of: self)) ::: \(#function)"
      case .errorDeletingPlayer:
        return "Cant get specific Player object to delete: \(type(of: self)) ::: \(#function)"
    }
  }
}
