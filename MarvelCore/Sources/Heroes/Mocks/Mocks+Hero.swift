#if DEBUG
import Foundation
import IdentifiedCollections

extension Hero {
    static var mock: Self {
        Hero(
            id: "0",
            heroId: 0,
            imageURL: nil,
            name: "Hulk",
            shortDescription: "Hulk is Hulk"
        )
    }
}

extension Array where Element == Hero {
    static var mock: [Hero] {
        [
            Hero(
                id: "1",
                heroId: 1,
                imageURL: nil,
                name: "Iron Man",
                shortDescription: "Genius billionaire playboy philanthropist."
            ),
            Hero(
                id: "2",
                heroId: 2,
                imageURL: nil,
                name: "Captain America",
                shortDescription: "The first Avenger."
            ),
            Hero(
                id: "3",
                heroId: 3,
                imageURL: nil,
                name: "Thor",
                shortDescription: "God of Thunder."
            )
        ]
    }
}
extension Array where Element == HeroListRowFeature.State {
    static var mock: [HeroListRowFeature.State] {
        [
            HeroListRowFeature.State(
                hero: Hero(
                    id: "1",
                    heroId: 1,
                    imageURL: nil,
                    name: "Iron Man",
                    shortDescription: "Genius billionaire playboy philanthropist."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: "2",
                    heroId: 2,
                    imageURL: nil,
                    name: "Captain America",
                    shortDescription: "The first Avenger."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: "3",
                    heroId: 3,
                    imageURL: nil,
                    name: "Thor",
                    shortDescription: "God of Thunder."
                )
            )
        ]
    }

}
#endif
