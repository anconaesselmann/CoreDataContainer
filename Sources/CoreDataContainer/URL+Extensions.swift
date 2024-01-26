//  Created by Axel Ancona Esselmann on 1/26/24.
//

import Foundation

extension URL {
    var locationString: String {
        #if os(macOS)
        if #available(macOS 13.0, *) {
           return path(percentEncoded: false)
       }
        #else
        if #available(iOS 16.0, *) {
            return path(percentEncoded: false)
        }
        #endif
        return absoluteString
    }
}
