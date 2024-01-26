//  Created by Axel Ancona Esselmann on 9/15/23.
//

import Foundation
import CoreData

public protocol CoreDataContainer {
    var persistentStoreDescriptions: [NSPersistentStoreDescription] { get set }
    func loadPersistentStores(completionHandler block: @escaping (NSPersistentStoreDescription, Error?) -> Void)
    var viewContext: NSManagedObjectContext { get }
    func newBackgroundContext() -> NSManagedObjectContext
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func loadPersistentStores() async throws
}

extension NSPersistentContainer: CoreDataContainer {}

public extension NSPersistentContainer {
    convenience init(
        model: String,
        subdirectory: String? = nil,
        type: CoreDataType = .localDefault,
        printLocation: Bool = false
    ) throws {
        self.init(name: model)
        switch type {
        case .inMemory:
            self.persistentStoreDescriptions.first?.url = URL.devNull
        case .local(let name):
            let containerUrl = try DbStorageManger.shared.dbPath(
                name: name,
                subdirectory: subdirectory
            )
            let description = NSPersistentStoreDescription(url: containerUrl)
            persistentStoreDescriptions[0] = description
        }
        if let location = persistentStoreDescriptions.first?.url, printLocation {
            self.printLocation(location)
        }
        viewContext.automaticallyMergesChangesFromParent = true
    }

    func loadPersistentStores() async throws {
        try await withCheckedThrowingContinuation { [unowned self] (continuation: CheckedContinuation<Void, Error>) in
            self.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            })
        }
    }

    private func printLocation(_ url: URL) {
        #if DEBUG
        print("Core data location: \(url.locationString)")
        #endif
    }
}
