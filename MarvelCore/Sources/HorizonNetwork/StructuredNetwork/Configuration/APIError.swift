import Foundation

public enum APIError: Error, LocalizedError, Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }

    case badRequest
    case serverError(statusCode: Int)
    case tooManyRequests(remaining: Int)
    case unAuthorized
    case decodingError
    case timeout
    case noInternetConnection
    case unknown(Error)
    case emptyData
    case missingURL
    case encodingFailed
    case jsonParsingFailed(error: DecodingError)
    case outdated
    case invalidURL
}

public protocol APIErrorHandler {
    static func handleNetworkResponse(data: Data?, response: URLResponse?) -> APIError
}

public extension APIErrorHandler {
      static func handleNetworkResponse(data: Data?, response: URLResponse?) -> APIError {
        guard let httpResponse = response as? HTTPURLResponse else {
            return .unknown(NSError(domain: "InvalidResponse", code: 0, userInfo: nil))
        }

        switch httpResponse.statusCode {
        case 200...299:
            return .unknown(NSError(domain: "UnexpectedSuccess", code: httpResponse.statusCode, userInfo: nil))
        case 400:
            return .badRequest
        case 401:
            return .unAuthorized
        case 408:
            return .timeout
        case 429:
            let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") ?? "0"
            return .tooManyRequests(remaining: Int(retryAfter) ?? 0)
        case 500...599:
            return .serverError(statusCode: httpResponse.statusCode)
        case 600:
            return .outdated
        default:
            return .unknown(NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil))
        }
    }
}
