import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroListTests {
    @Test
    func heroListLoaded() {
        let originalLocale = Locale.current
        let originalTimeZone = TimeZone.current
        
        // Force consistent values
        setenv("LANG", "en_US.UTF-8", 1)
        setenv("TZ", "UTC", 1)
        
        defer {
            // Clean up if needed
            unsetenv("LANG")
            unsetenv("TZ")
        }
        
        let view = NavigationStack {
            HeroListView(
                store: Store(
                    initialState: HeroListFeature.State(
                        heroes: IdentifiedArray(uniqueElements: [HeroListRowFeature.State].mock),
                        repositoryState: HeroUseCaseFeature.State()
                    ),
                    reducer: { HeroListFeature()
                    }
                )
            )
            .navigationTitle("Heros")
        }
            .frame(width: 375, height: 812)
            .environment(\.locale, Locale(identifier: "en_US"))
            .environment(\.timeZone, TimeZone(identifier: "UTC")!)
        assertSnapshot(of: view, as: .image)
    }
}
