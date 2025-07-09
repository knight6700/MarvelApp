import Foundation

public struct RequestConfiguration {

    // MARK: - Properties

    let path: String
    let method: HTTPMethod
    let headers: [HTTPHeader]?
    let parameters: Encodable?
    let encoding: ParameterEncoding?
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let uRLSession: URLSession
    public init(
        method: HTTPMethod = .get,
        path: String,
        parameters: Encodable? = nil,
        encoding: ParameterEncoding = .urlEncoding,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
        uRLSession: URLSession = URLSession.shared
    ) {
        self.path = path
        self.method = method
        self.headers = [
            HTTPHeader(name: "Accept", value: "application/json"),
            HTTPHeader(name: "Content-Type", value: "application/json")
        ]
        self.parameters = parameters
        self.encoding = encoding
        self.encoder = encoder
        self.decoder = decoder
        self.uRLSession = uRLSession
    }
}
