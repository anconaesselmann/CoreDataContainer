//  Created by Axel Ancona Esselmann on 9/15/23.
//

import Foundation

public enum CoreDataType: Identifiable {

    public var id: String {
        switch self {
        case .inMemory:
            return "inMemory"
        case .local(name: let name):
            return "local_\(name)"
        }
    }

    case inMemory, local(name: String)

    public static let localDefault: Self = .local(name: "default")

    public init(isLocal: Bool) {
        if isLocal {
            self = .local(name: "default")
        } else {
            self = .inMemory
        }
    }

    public var isLocal: Bool {
        switch self {
        case .local: return true
        default: return false
        }
    }

    public var isMemory: Bool {
        switch self {
        case .local: return true
        default: return false
        }
    }
}
