import Foundation

public protocol RemoteService {
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var basePath: String { get }
    var requestConfiguration: RequestConfiguration { get }
    var generateMarvelSignature: GenerateMarvelSignature { get }
    var fullURL: URL? { get }
}

public extension RemoteService {
    var fullURL: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port

        let combinedPath = basePath
            .appendingPathComponent(requestConfiguration.path)

        components.path = combinedPath

        guard let url = components.url else {
            return nil
        }

        return url
    }

    func asURLRequest() throws -> URLRequest {
        guard let fullURL else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: fullURL, cachePolicy: .returnCacheDataElseLoad)
        request.httpMethod = requestConfiguration.method.rawValue

        if let headers = requestConfiguration.headers {
            for header in headers {
                request.setValue(header.value, forHTTPHeaderField: header.name)
            }
        }

        if let parameters = requestConfiguration.parameters {
            try requestConfiguration.encoding?.encode(
                urlRequest: &request,
                parameters: parameters,
                encoder: requestConfiguration.encoder
            )
        }
        
        try requestConfiguration.encoding?.encode(
            urlRequest: &request,
            parameters: MarvelAuthParameters(
                apiKey: generateMarvelSignature.apiKey,
                timestamp: generateMarvelSignature.timestamp,
                hash: generateMarvelSignature.hash
            ),
            encoder: requestConfiguration.encoder
        )
        return request
    }
}

fileprivate extension String {
    func appendingPathComponent(_ path: String) -> String {
        let trimmedBase = self.hasSuffix("/") ? String(self.dropLast()) : self
        let trimmedPath = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return "\(trimmedBase)/\(trimmedPath)"
    }
}
public struct MarvelServices: RemoteService {
    public var generateMarvelSignature: GenerateMarvelSignature
    public let requestConfiguration: RequestConfiguration
    public init(
        requestConfiguration: RequestConfiguration,
        generateMarvelSignature: GenerateMarvelSignature = .liveValue
    ) {
        self.requestConfiguration = requestConfiguration
        self.generateMarvelSignature = generateMarvelSignature
    }
}

public extension MarvelServices {
    var scheme: String { "https" }
    var host: String { AppConfig.environment.baseHost }
    var port: Int? { AppConfig.environment.basePort }
    var basePath: String { "/v1/public/" }
}
