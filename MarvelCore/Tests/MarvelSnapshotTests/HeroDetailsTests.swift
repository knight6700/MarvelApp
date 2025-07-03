import Testing
import SwiftUI
import SnapshotTesting
import ComposableArchitecture
@testable import Heroes

@MainActor
struct HeroDetailsTests {
    @Test
    func heroDetailsLoaded() {
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
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
