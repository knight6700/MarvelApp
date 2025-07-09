import Foundation

struct ResourcesDTO: Codable {
    let offset, limit, total, count: Int
    let results: [ResourcesResult]
}

// MARK: - Result
struct ResourcesResult: Codable {
    let id: Int
    let digitalID: Int?
    let title: String
    let issueNumber: Int?
    let variantDescription: VariantDescription?
    let description: String?
    let isbn: String?
    let upc, diamondCode: String?
    let ean: Ean?
    let issn: String?
    let format: Format?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [URLElement]?
    let series: Series?
    let variants, collections: [Series]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title,
             issueNumber,
             variantDescription,
             description,
             isbn,
             upc,
             diamondCode,
             ean, issn,
             format,
             pageCount,
             textObjects,
             resourceURI,
             urls,
             series,
             variants,
             collections,
             dates,
             prices,
             thumbnail,
             images,
             creators,
             characters,
             stories,
             events
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int
    let collectionURI: String
    let items: [Series]
    let returned: Int
}

// MARK: - Series
struct Series: Codable {
    let resourceUrl: String?
    let name: String?
    enum CodingKeys: String, CodingKey {
        case resourceUrl = "resourceURI"
        case name
    }
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int
    let collectionURI: String
    let items: [CreatorsItem]
    let returned: Int
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String
    let name, role: String
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: DateType
    let date: String
}

enum DateType: String, Codable {
    case digitalPurchaseDate
    case focDate
    case onsaleDate
    case unlimitedDate
}

enum Ean: String, Codable {
    case empty = ""
    case the978078515260651499 = "9780785 152606 51499"
    case the978130290774753999 = "9781302 907747 53999"
    case the978130291013653999 = "9781302 910136 53999"
}

enum Format: String, Codable {
    case comic = "Comic"
    case digitalVerticalComic = "Digital Vertical Comic"
    case infiniteComic = "Infinite Comic"
    case tradePaperback = "Trade Paperback"
}

// MARK: - Price
struct Price: Codable {
    let type: PriceType
    let price: Double
}

enum PriceType: String, Codable {
    case digitalPurchasePrice
    case printPrice
}

// MARK: - TextObject
struct TextObject: Codable {
    let type: TextObjectType
    let language: Language
    let text: String
}

enum Language: String, Codable {
    case enUs = "en-us"
}

enum TextObjectType: String, Codable {
    case issuePreviewText = "issue_preview_text"
    case issueSolicitText = "issue_solicit_text"
}

enum VariantDescription: String, Codable {
    case empty = ""
    case variant = "VARIANT"
}
