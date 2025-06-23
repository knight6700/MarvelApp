import Dependencies
import Foundation

struct PaginationUseCase {
    let shouldLoadMore: @Sendable (_ config: PaginationConfig) -> Bool
}

struct PaginationConfig {
    let currentItemId: String
    let loadedItemsCount: Int
    let totalItemsCount: Int
    let paginationThreshold: Int
    let loadedItems: [String]
}

extension PaginationUseCase: DependencyKey {
    static var liveValue: Self {
        PaginationUseCase { config in
            guard config.loadedItemsCount > config.paginationThreshold else {
                return false
            }
            
            let triggerIndex = config.loadedItemsCount - config.paginationThreshold
            guard triggerIndex >= 0 && triggerIndex < config.loadedItems.count else {
                return false
            }
            
            let triggerItemId = config.loadedItems[triggerIndex]
            
            return config.currentItemId == triggerItemId && 
                   config.totalItemsCount > config.loadedItemsCount - 1
        }
    }
}

extension PaginationUseCase: TestDependencyKey {
    static var testValue: Self {
        PaginationUseCase { config in
            config.loadedItemsCount < config.totalItemsCount
        }
    }
    
    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var paginationUseCase: PaginationUseCase {
        get { self[PaginationUseCase.self] }
        set { self[PaginationUseCase.self] = newValue }
    }
}