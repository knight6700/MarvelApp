import Foundation

public struct ResourceItem: Identifiable, Equatable {
    public let id: Int
    let imageURL: URL?
    let resourceURL: URL?
    let name: String
    let description: String?
    let price: [PriceResource]
}
struct PriceResource: Equatable {
    let price: Double
    let priceType: PriceResourceType
}

enum PriceResourceType: String, Equatable {
    case digitalPurchasePrice
    case printPrice
}
