import Dependencies

struct DateProvider {
    var generate: @Sendable () -> Int
}

extension DateProvider: DependencyKey {
    static var liveValue: DateProvider  {
        @Dependency(\.date) var dateProvider
      return DateProvider {
            Int(dateProvider.now.timeIntervalSince1970)
        }
    }
}
extension DependencyValues {
    var dateProvider: DateProvider {
        get { self[DateProvider.self] }
        set { self[DateProvider.self] = newValue }
    }
}
