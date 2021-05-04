//
//  CoreDataService.swift
//  FootballManager
//
//  Created by Vladimir Banushkin on 22.01.2021.
//

import CoreData

final class CoreDataService: NSObject {
  private let modelName: String
  private let searchPredicatesConstructor = SearchPredicateConstructor()
  //MARK: - Initialization
  init(modelName: String) {
    self.modelName = modelName

  }
  
  lazy private var container: NSPersistentContainer = {
    let container = NSPersistentContainer(name: modelName)
    container.loadPersistentStores {_, error in
      if let error = error {
        print(error.localizedDescription)
      }
    }
    return container
  }()
  
  func getContext() -> NSManagedObjectContext {
    return container.viewContext
  }
  
  // MARK: - Save context method
  func save() {
    let context = getContext()
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let error = error as NSError
        fatalError("Fatal error: \(error) \(error.userInfo)")
      }
    }
  }
  
  //MARK: - Generic creating NSManagedObject method
  func createObject<T>(from entity: T.Type) -> T? {
    let context = getContext()
    guard let type = entity as? NSManagedObject.Type else { return nil }
    let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: type), into: context) as! T
    return object
  }
  
  //MARK: - Delete NSManagedObject method
  func deleteObject<T: NSManagedObject> (object: T) {
    let context = getContext()
    context.delete(object)
    save()
  }
  
  //MARK: - Generic data fetch method
  func fetchData<T: NSManagedObject> (for entity: T.Type) -> [T]? {
    let context = getContext()
    let request: NSFetchRequest<T>
    var fetchedResult = [T]()
    request = NSFetchRequest(entityName: String(describing: entity))
    do  {
      fetchedResult = try context.fetch(request)
    } catch {
      debugPrint("Error occurred: \(error.localizedDescription)")
    }
    return fetchedResult
  }
  
  func fetchData<T: NSManagedObject> (for entity: T.Type, with predicate: NSPredicate) -> [T]? {
    let context = getContext()
    let request: NSFetchRequest<T>
    var fetchedResult = [T]()
    request = NSFetchRequest(entityName: String(describing: entity))
    request.predicate = predicate
    do  {
      fetchedResult = try context.fetch(request)
    } catch {
      debugPrint("Error occurred: \(error.localizedDescription)")
    }
    return fetchedResult
  }

  func fetchData<T: NSManagedObject> (for entity: T.Type, with predicates: NSCompoundPredicate) -> [T]? {
    let context = getContext()
    let request: NSFetchRequest<T>
    var fetchedResult = [T]()
    request = NSFetchRequest(entityName: String(describing: entity))
    request.predicate = predicates
    do  {
      fetchedResult = try context.fetch(request)
    } catch {
      debugPrint("Error occurred: \(error.localizedDescription)")
    }
    return fetchedResult
  }
}

extension CoreDataService: MainScreenServiceInterface {

  func fetchData (by fields: [String : Any], completionHandler: @escaping (Result<[Player], DataError>) -> ()) {
    let predicates = searchPredicatesConstructor.getPredicates(by: fields)
    if predicates.count == 1 {
      guard let predicate = predicates.first else {
        completionHandler(.failure(.fetchError))
        return
      }
      guard let players = fetchData(for: Player.self, with: predicate) else {
        completionHandler(.failure(.fetchError))
        return
      }
      completionHandler(.success(players))
    } else {
      let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
      guard  let players = fetchData(for: Player.self, with: compoundPredicate) else {
        completionHandler(.failure(DataError.fetchError))
        return
      }
      completionHandler(.success(players))
    }
  }

  func fetchData(completionHandler: @escaping (Result<[Player], DataError>) -> ()) {
    guard let playersData = fetchData(for: Player.self) else {
      completionHandler(.failure(.fetchError))
      return
    }
    completionHandler(.success(playersData))
  }
  
  func deletePlayer(by id: UUID) throws {
    let predicate = NSPredicate(format: "id == %@", id.uuidString)
    guard let specificPlayer = fetchData(for: Player.self, with: predicate)?.first else {
      throw DataError.errorDeletingPlayer
    }
    deleteObject(object: specificPlayer)
  }

  // MARK: This must be shared method
  func getSpecificPlayer(by id: UUID) throws -> Player {
    let predicate = NSPredicate(format: "id == %@", id.uuidString)
    guard let specificPlayer = fetchData(for: Player.self, with: predicate)?.first else {
      throw DataError.errorDeletingPlayer
    }
    return specificPlayer
  }
}

extension CoreDataService: AddPlayerServiceInterface {
  func createNSManagedPlayer() -> Player {
    guard let player = self.createObject(from: Player.self) else { return Player()}
    return player
  }


}

class SearchPredicateConstructor {
  func getPredicates(by fields: [String: Any]) -> [NSPredicate] {
    var predicates = [NSPredicate]()
    for (key, value) in fields where key != "comparisonSign" {
      if let value = value as? Bool {
        let predicate = NSPredicate(format: "\(key) == %@", NSNumber(booleanLiteral: value))
        predicates.append(predicate)
      }
      if let value = value as? String {
        if let value = Int16(value), let sign = fields["comparisonSign"] as? String  {
          let predicate = NSPredicate(format: "\(key) \(sign) %i", value)
          predicates.append(predicate)
        }
        else {
          let predicate = NSPredicate(format: "\(key) CONTAINS[c] %@", value)
          predicates.append(predicate)
        }
      }
    }
    return predicates
  }
}
