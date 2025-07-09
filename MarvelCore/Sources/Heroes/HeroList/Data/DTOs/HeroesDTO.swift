import Foundation

struct HeroesDTO: Codable {
    let offset, limit, total, count: Int
    let results: [HeroResult]
}

// MARK: - Result
struct HeroResult: Codable {
    let id: Int
    let name, description: String
    let modified: Date
    let thumbnail: Thumbnail
    let resourceURI: String?
    let comics, series: Comics
    let stories: Stories
    let events: Comics
    let urls: [URLElement]
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [ComicsItem]
    let returned: Int
}

// MARK: - ComicsItem
struct ComicsItem: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int
    let collectionURI: String
    let items: [StoriesItem]
    let returned: Int
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String
    let name: String
    let type: ItemType
}

enum ItemType: String, Codable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
    case pinup = "pinup"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = ItemType(rawValue: rawValue) ?? .unknown
    }
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: Extension

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

enum Extension: String, Codable {
    case gif
    case jpg
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: URLType?
    let url: String
}

enum URLType: String, Codable {
    case comicLink = "comiclink"
    case detail = "detail"
    case wiki = "wiki"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = URLType(rawValue: rawValue) ?? .unknown
    }
}
