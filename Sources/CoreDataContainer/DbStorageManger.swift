//  Created by Axel Ancona Esselmann on 7/5/23.
//

import Foundation
import FileUrlExtensions

struct DbStorageManger {

    static let shared = DbStorageManger()

    func dbDirectory(name: String? = nil, create: Bool = true) throws -> URL {
        let name = name ?? dbName
        return try URL.appLibraryDirectory()
            .appendingPathComponent("db")
            .appendingPathComponent(name)
            .create(create)
    }

    func dbPath(
        name: String? = nil,
        subdirectory: String? = nil,
        create: Bool = true
    ) throws -> URL {
        let name = name ?? dbName
        return try dbDirectory(name: subdirectory ?? name, create: true)
            .appendingPathComponent(name + ".sqlite")
    }

    func dbExists(name: String? = nil) -> Bool {
        (try? dbPath(name: name).exists()) ?? false
    }

    var dbName: String {
        UserDefaults.standard.string(forKey: "CoreDataContainer.dbName") ?? "default"
    }
}
