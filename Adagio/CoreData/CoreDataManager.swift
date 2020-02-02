//
//  CoreDataManager.swift
//  CustomCoreData
//
//  Created by Ethan Pippin on 1/2/20.
//  Copyright © 2020 Ethan Pippin. All rights reserved.
//

import CoreData
import Foundation
import SharedPips

public class CoreDataManager {
    
    // MARK: - Properties
    
    public private(set) static var main: CoreDataManager!
    
    private let modelName: String
    
    private let initCompletion: () -> Void
    
    public static let saveNotification = Notification.Name("saveNotification")
    
    // MARK: - init
    
    private init(modelName: String, completion: @escaping () -> Void) {
        self.modelName = modelName
        self.initCompletion = completion
        
        setupCoreDataStack()
    }
    
    // MARK: - Start
    
    public static func start(modelName: String, completion: @escaping () -> Void) {
        main = CoreDataManager(modelName: modelName, completion: completion)
    }
    
    // MARK: - Fetch
    func fetch<Object>(request: NSFetchRequest<Object>, completion: @escaping ([Object]) -> Void) where Object: NSManagedObject {
        privateManagedObjectContext.performAndWait {
            do {
                let objects: [Object] = try request.execute()
                completion(objects)
            } catch let error as NSError {
                assertionFailure("ERROR: While fetching objects: \(error)")
                completion([])
            }
        }
    }
    
    // MARK: - Save
    /**
        Saves the changes from the `mainManagedObjectContext` to disk.
        Only calls `completion` if successfully written to disk.
     */
    public func saveChanges(completion: ((Result<Bool, Error>) -> Void)? = nil) {
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                } else {
                    completion?(.success(true))
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                    completion?(.success(true))
                } else {
                    completion?(.success(true))
                }
                NotificationCenter.default.post(name: CoreDataManager.saveNotification, object: nil)
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
    }
    
    public func save(object: NSManagedObject, completion: ((Result<NSManagedObject, Error>) -> Void)? = nil) {
        guard let objectContext = object.managedObjectContext else {
            completion?(.failure(SimpleError("No managed object context")))
            return }
        
        objectContext.performAndWait {
            do {
                if objectContext.hasChanges {
                    try objectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
        
        mainManagedObjectContext.performAndWait {
            do {
                if self.mainManagedObjectContext.hasChanges {
                    try self.mainManagedObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
        
        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                    completion?(.success(object))
                    NotificationCenter.default.post(name: CoreDataManager.saveNotification, object: nil)
                }
            } catch {
                print("Unable to Save Changes of Private Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Purge
    
    public func purge() {
        for key in mainManagedObjectContext.persistentStoreCoordinator?.managedObjectModel.entities.compactMap({ $0.name }) ?? [] {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: key)
            do {
                try actuallyPurge(with: request)
            } catch let error as NSError {
                print(error)
            }
        }
        saveChanges()
        NotificationCenter.default.post(name: CoreDataManager.saveNotification, object: nil)
    }
    
    private func actuallyPurge(with request: NSFetchRequest<NSFetchRequestResult>) throws {
        guard let objects = try mainManagedObjectContext.fetch(request) as? [NSManagedObject] else { return }
        for object in objects {
            mainManagedObjectContext.delete(object)
        }
    }
    
    // MARK: - Core Data Stack
    
    private func setupCoreDataStack() {
        // Fetch Persistent Store Coordinator
        guard let persistentStoreCoordinator = mainManagedObjectContext.persistentStoreCoordinator else {
            fatalError("Unable to Set Up Core Data Stack")
        }
        
        DispatchQueue.global().async {
            // Add Persistent Store
            self.addPersistentStore(to: persistentStoreCoordinator)
            
            // Invoke Completion On Main Queue
            DispatchQueue.main.async { self.initCompletion() }
        }
    }
    
    // MARK: - AddPersistentStore
    private func addPersistentStore(to persistentStoreCoordinator: NSPersistentStoreCoordinator) {
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            let options = [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true
            ]
            
            // Add Persistent Store
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: options)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
    }
    
    // MARK: - MainManagedObjectContext
    public private(set) lazy var mainManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = self.privateManagedObjectContext
        
        return managedObjectContext
    }()
    
    // MARK: - PrivateChildManagedObjectContext
    public func privateChildManagedObjectContext() -> NSManagedObjectContext {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.parent = mainManagedObjectContext
        
        return managedObjectContext
    }
    
    // MARK: - PrivateManagedObjectContext
    private lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // MARK: - ManagedObjectModel
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    // MARK: - PersistentStoreCoordinator
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        return NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    }()
}

extension NSManagedObjectContext {
    
    /**
        Saves the current context. If `writeToDisk` is `true`, will save to disk through a private context object
     */
    func save(writeToDisk: Bool = false, completion: ((Result<Bool, Error>) -> Void)? = nil) {
        self.performAndWait {
            do {
                if self.hasChanges {
                    try self.save()
                    if writeToDisk {
                        CoreDataManager.main.saveChanges(completion: completion)
                    } else {
                        completion?(.success(true))
                    }
                } else {
                    completion?(.success(true))
                }
            } catch {
                print("Unable to Save Changes of Main Managed Object Context")
                print("\(error), \(error.localizedDescription)")
                completion?(.failure(error))
            }
        }
    }
}

extension NSManagedObject {
    
    func save(writeToDisk: Bool = false, completion: ((Result<Bool, Error>) -> Void)? = nil) {
        guard let objectContext = self.managedObjectContext else {
            completion?(.failure(SimpleError("No managed object context")))
            return }
        objectContext.save(writeToDisk: writeToDisk, completion: completion)
    }
    
    func delete(writeToDisk: Bool = false, completion: ((Result<Bool, Error>) -> Void)? = nil) {
        guard let objectContext = self.managedObjectContext else {
            completion?(.failure(SimpleError("No managed object context")))
            return }
        
        objectContext.performAndWait {
            objectContext.delete(self)
            objectContext.save(writeToDisk: writeToDisk, completion: completion)
        }
    }
}
