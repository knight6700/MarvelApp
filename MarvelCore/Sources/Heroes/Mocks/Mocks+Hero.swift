#if DEBUG
import Foundation
import IdentifiedCollections

extension Hero {
    static var mock: Self {
        Hero(
            id: "00000000-0000-0000-0000-000000000000",
            heroId: 0,
            imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
            name: "Hulk",
            shortDescription: "Hulk is Hulk"
        )
    }
}

extension Array where Element == Hero {
    static var mock: [Hero] {
        [
            Hero(
                id: "00000000-0000-0000-0000-000000000000",
                heroId: 1,
                imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                name: "Iron Man",
                shortDescription: "Genius billionaire playboy philanthropist."
            ),
            Hero(
                id: "00000000-0000-0000-0000-000000000001",
                heroId: 2,
                imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                name: "Captain America",
                shortDescription: "The first Avenger."
            ),
            Hero(
                id: "00000000-0000-0000-0000-000000000002",
                heroId: 3,
                imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                name: "God of Thunder.",
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
                    id: "00000000-0000-0000-0000-000000000000",
                    heroId: 1,
                    imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                    name: "Iron Man",
                    shortDescription: "Genius billionaire playboy philanthropist."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: "00000000-0000-0000-0000-000000000001",
                    heroId: 2,
                    imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                    name: "Captain America",
                    shortDescription: "The first Avenger."
                )
            ),
            HeroListRowFeature.State(
                hero: Hero(
                    id: "00000000-0000-0000-0000-000000000002",
                    heroId: 3,
                    imageURL: URL(string: "https://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16.jpg"),
                    name: "God of Thunder.",
                    shortDescription: "God of Thunder."
                )
            )
        ]
    }

}
#endif
