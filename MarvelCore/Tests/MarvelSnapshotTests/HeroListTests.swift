import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroListTests {
    @Test
    func heroListLoaded() {
        
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
        assertSnapshot(of: view, as: .image)
    }
}
