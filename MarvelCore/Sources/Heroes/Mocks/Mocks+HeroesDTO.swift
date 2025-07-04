#if DEBUG
import Foundation

extension HeroesDTO {
    static var mock: HeroesDTO {
        .init(
            offset: 0,
            limit: 20,
            total: 3,
            count: 3,
            results: .mock
        )
    }
}

extension Array where Element == HeroResult {
    static var mock: [HeroResult] {
        [
            HeroResult(
                id: 1,
                name: "Iron Man",
                description: "Genius billionaire playboy philanthropist.",
                modified: Date(),
                thumbnail: .mock,
                resourceURI: nil,
                comics: .mock,
                series: .mock,
                stories: .mock,
                events: .mock,
                urls: [.mockDetail, .mockWiki, .mockComicLink]
            ),
            HeroResult(
                id: 2,
                name: "Captain America",
                description: "The first Avenger.",
                modified: Date(),
                thumbnail: .mock,
                resourceURI: nil,
                comics: .mock,
                series: .mock,
                stories: .mock,
                events: .mock,
                urls: [.mockDetail, .mockWiki, .mockComicLink]
            ),
            HeroResult(
                id: 3,
                name: "God of Thunder.",
                description: "God of Thunder.",
                modified: Date(),
                thumbnail: .mock,
                resourceURI: nil,
                comics: .mock,
                series: .mock,
                stories: .mock,
                events: .mock,
                urls: [.mockDetail, .mockWiki, .mockComicLink]
            )

        ]
    }
}

extension Thumbnail {
    static var mock: Thumbnail {
        .init(
            path: "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16",
            thumbnailExtension: .jpg
        )
    }
}

extension Comics {
    static var mock: Comics {
        .init(
            available: 12,
            collectionURI: "http://gateway.marvel.com/v1/public/characters/1009610/comics",
            items: [
                .init(resourceURI: "http://gateway.marvel.com/v1/public/comics/62304", name: "Amazing Spider-Man (2018) #1")
            ],
            returned: 1
        )
    }
}

extension Stories {
    static var mock: Stories {
        .init(
            available: 2,
            collectionURI: "http://gateway.marvel.com/v1/public/characters/1009610/stories",
            items: [
                .init(resourceURI: "http://gateway.marvel.com/v1/public/stories/1234", name: "Cover #1234", type: .cover),
                .init(resourceURI: "http://gateway.marvel.com/v1/public/stories/5678", name: "Interior #5678", type: .interiorStory)
            ],
            returned: 2
        )
    }
}

extension URLElement {
    static var mockDetail: URLElement {
        .init(type: .detail, url: "http://marvel.com/characters/54/spider-man?utm_campaign=apiRef&utm_source=xyz")
    }

    static var mockWiki: URLElement {
        .init(type: .wiki, url: "http://marvel.com/universe/Spider-Man_(Peter_Parker)?utm_campaign=apiRef&utm_source=xyz")
    }

    static var mockComicLink: URLElement {
        .init(type: .comicLink, url: "http://marvel.com/comics/characters/1009610/spider-man?utm_campaign=apiRef&utm_source=xyz")
    }
}
#endif
