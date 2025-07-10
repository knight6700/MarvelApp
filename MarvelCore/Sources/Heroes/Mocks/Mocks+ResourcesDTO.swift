#if DEBUG
import Foundation

extension ResourcesDTO {
    static var mock: ResourcesDTO {
        ResourcesDTO(
            offset: 0,
            limit: 20,
            total: 100,
            count: 1,
            results: [.mock]
        )
    }
}

extension ResourcesResult {
    static var mock: ResourcesResult {
        ResourcesResult(
            id: 1,
            digitalID: 101,
            title: "Mock Comic Title",
            issueNumber: 12,
            variantDescription: .variant,
            description: "This is a mock description of the comic issue.",
            isbn: "978-1-302-90349-7",
            upc: "123456789012",
            diamondCode: "DIAMOND123",
            ean: .the978130290774753999,
            issn: "1941-2142",
            format: .comic,
            pageCount: 32,
            textObjects: [.mock],
            resourceURI: "http://mock.resource.uri",
            urls: [.mock],
            series: .mock,
            variants: [.mock],
            collections: [.mock],
            dates: [.mock],
            prices: [.mock],
            thumbnail: .mock,
            images: [.mock],
            creators: .mock,
            characters: .mock,
            stories: .mock,
            events: .mock
        )
    }
}

extension TextObject {
    static let mock: TextObject = .init(
        type: .issuePreviewText,
        language: .enUs,
        text: "Mock text object for preview."
    )
}

extension URLElement {
    static var mock: URLElement {
        URLElement(
            type: .detail,
            url: "https://example.com"
        )
    }
}

extension Series {
    static var mock: Series {
        Series(
            resourceUrl: "http://mock.series.uri",
            name: "Mock Series Name"
        )
    }
}

extension DateElement {
    static var mock: DateElement {
        DateElement(
            type: .onsaleDate,
            date: "2024-01-01T00:00:00Z"
        )
    }
}

extension Price {
    static var mock: Price {
        Price(
            type: .printPrice,
            price: 4.99
        )
    }
}

extension Creators {
    static var mock: Creators {
        Creators(
            available: 1,
            collectionURI: "http://mock.creators.uri",
            items: [.mock],
            returned: 1
        )
    }
}

extension CreatorsItem {
    static var mock: CreatorsItem {
        CreatorsItem(
            resourceURI: "http://mock.creator.item.uri",
            name: "Mock Creator",
            role: "writer"
        )
    }
}

extension Characters {
    static var mock: Characters {
        Characters(
            available: 1,
            collectionURI: "http://mock.characters.uri",
            items: [.mock],
            returned: 1
        )
    }
}

#endif
