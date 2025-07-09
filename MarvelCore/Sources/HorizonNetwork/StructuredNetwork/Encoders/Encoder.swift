import Foundation

protocol ParameterEncoder {
    func encode(
        urlRequest: inout URLRequest,
        with parameters: Encodable,
        encoder: JSONEncoder
    ) throws
}

struct JSONParameterEncoder: ParameterEncoder {
    func encode(
        urlRequest: inout URLRequest,
        with parameters: Encodable,
        encoder: JSONEncoder
    ) throws {
        do {
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            let jsonAsData = try encoder.encode(parameters)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw APIError.encodingFailed
        }
    }
}

public struct URLParameterEncoder: ParameterEncoder {
    public func encode(
        urlRequest: inout URLRequest,
        with parameters: Encodable,
        encoder: JSONEncoder
    ) throws {
        guard let url = urlRequest.url else {
            throw APIError.missingURL
        }

        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(parameters)

        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw APIError.encodingFailed
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !jsonObject.isEmpty {
            var existingItems = urlComponents.queryItems ?? []
            
            for (key, value) in jsonObject where !existingItems.contains(where: { $0.name == key }) {
                existingItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            urlComponents.queryItems = existingItems
            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8",
                                forHTTPHeaderField: "Content-Type")
        }
    }
}

public enum ParameterEncoding {
    case urlEncoding
    case jsonEncoding

    public func encode(
        urlRequest: inout URLRequest,
        parameters: Encodable?,
        encoder: JSONEncoder
    ) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = parameters else { return }
                try URLParameterEncoder().encode(
                    urlRequest: &urlRequest,
                    with: urlParameters,
                    encoder: encoder
                )

            case .jsonEncoding:
                guard let bodyParameters = parameters else { return }
                try JSONParameterEncoder().encode(
                    urlRequest: &urlRequest,
                    with: bodyParameters,
                    encoder: encoder
                )
            }
        } catch {
            throw error
        }
    }
}
