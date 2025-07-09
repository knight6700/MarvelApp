import Dependencies
import Foundation

struct SearchSuggestionsUseCase {
    let filterSuggestions: @Sendable (
        _ suggestions: [SearchSuggestions],
        _ query: String
    ) -> [SearchSuggestions]
}

extension SearchSuggestionsUseCase: DependencyKey {
    static var liveValue: Self {
        SearchSuggestionsUseCase { suggestions, query in
            guard !query.isEmpty else { return suggestions }
            
            return suggestions
                .filter { $0.name.localizedCaseInsensitiveContains(query) }
                .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        }
    }
}

extension SearchSuggestionsUseCase: TestDependencyKey {
    static var testValue: Self {
        SearchSuggestionsUseCase { suggestions, query in
            suggestions.filter { $0.name.contains(query) }
        }
    }
    
    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var searchSuggestionsUseCase: SearchSuggestionsUseCase {
        get { self[SearchSuggestionsUseCase.self] }
        set { self[SearchSuggestionsUseCase.self] = newValue }
    }
}
