#if DEBUG
import Foundation
import IdentifiedCollections

extension IdentifiedArray where Element == ResourceGridRowFeature.State {
    static var mock: IdentifiedArrayOf<ResourceGridRowFeature.State> {
        [
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 1,
                    imageURL: .staticImage,
                    resourceURL: .staticImage,
                    name: "Sample Resource",
                    description: "This is a sample resource used for testing purposes.",
                    price: []
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 2,
                    imageURL: .staticImage,
                    resourceURL: .staticImage,
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    price: []
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 3,
                    imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/9/80/59d2acf17c923.jpg"),
                    resourceURL: .staticImage,
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    price: []
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 4,
                    imageURL: URL(string: "https://www.marvel.com/characters/abomination"),
                    resourceURL: .staticImage,
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    price: []
                )
            ),
            ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 5,
                    imageURL: .staticImage,
                    resourceURL: .staticImage,
                    name: "Another Resource",
                    description: "Another example resource for UI testing.",
                    price: []
                )
            )
        ]
    }
}
#endif
