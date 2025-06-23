
import Dependencies
import Foundation

struct UUIDGeneratorKey {
    var generate: @Sendable () -> String
}

extension UUIDGeneratorKey: DependencyKey {
    static var liveValue: UUIDGeneratorKey  {
        UUIDGeneratorKey {
            UUID().uuidString
        }
    }
}

extension DependencyValues {
    var uuidGenerator: UUIDGeneratorKey {
        get { self[UUIDGeneratorKey.self] }
        set { self[UUIDGeneratorKey.self] = newValue }
    }
}
