import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroDetailsTests {
    @Test
    func heroDetailsLoaded() {
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
        let view = HeroDetailsView(
            store: Store(
                initialState: HeroDetailsFeature.State(
                    sections: ResourcesSectionsFeature.State(
                        rows: [
                            ResourceSectionFeature.State(
                                sectionType: .comics,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                heroId: 1
                            ),
                            ResourceSectionFeature.State(
                                sectionType: .series,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                heroId: 2
                            ),
                            ResourceSectionFeature.State(
                                sectionType: .stories,
                                resources: ResourceGridRowsFeature.State(
                                    resourceDetailsRows: .mock
                                ),
                                heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                                heroId: 3
                            ),
                        ]
                    ),
                    hero: Hero(
                        id: "00000000-0000-0000-0000-000000000000",
                        heroId: 0,
                        imageURL: .staticImage,
                        name: "Fares",
                        shortDescription: "Fares Junior"
                    )
                ),
                reducer: {
                    HeroDetailsFeature()
                }
            )
        )
            .frame(width: 375, height: 812)
            .environment(\.locale, Locale(identifier: "en_US"))
            .environment(\.timeZone, TimeZone(identifier: "UTC")!)
        assertSnapshot(of: view, as: .image)
    }
}
