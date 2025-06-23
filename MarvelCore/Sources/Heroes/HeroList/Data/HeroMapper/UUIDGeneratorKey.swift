
import Dependencies

struct UUIDGeneratorKey {
    var generate: @Sendable () -> UUID
}

extension UUIDGeneratorKey: DependencyKey {
    static var liveValue: UUIDGeneratorKey  {
        UUIDGeneratorKey {
            UUID()
        }
    }
}
extension DependencyValues {
    var uuidGenerator: UUIDGeneratorKey {
        get { self[UUIDGeneratorKey.self] }
        set { self[UUIDGeneratorKey.self] = newValue }
    }
}
