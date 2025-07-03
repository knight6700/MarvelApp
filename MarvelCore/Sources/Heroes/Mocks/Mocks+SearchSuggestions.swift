#if DEBUG
import Foundation
import IdentifiedCollections
extension Array where Element == SearchSuggestions {
    static var mock: [SearchSuggestions] {
        [
            SearchSuggestions(id: 1, name: "Iron Man"),
            SearchSuggestions(id: 2, name: "Captain America"),
            SearchSuggestions(id: 3, name: "Thor")
        ]
    }
}

#endif
