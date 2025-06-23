import Foundation
import CryptoKit
import HorizonKeys
import Dependencies

public struct GenerateMarvelSignature {
    let apiKey: String
    let privateKey: String
    let timestamp: String
    
     var hash: String {
        generator.generate(timestamp, privateKey, apiKey)
    }
    
    let generator: Generator
        
    public init(
        generator: Generator,
        date: Int,
        apiKey: String,
        privateKey: String
    ) {
        self.timestamp = String(date)
        self.apiKey = apiKey
        self.privateKey = privateKey
        self.generator = generator
    }
}

extension GenerateMarvelSignature: DependencyKey {
    public static var liveValue: GenerateMarvelSignature {
        @Dependency(\.dateProvider) var dateProvider
        
        return GenerateMarvelSignature(
            generator: .liveValue,
            date: dateProvider.generate(),
            apiKey: AppConfig.publicKey,
            privateKey: AppConfig.privateKey
        )
    }
}

extension GenerateMarvelSignature: TestDependencyKey, Sendable {
    public static var testValue: GenerateMarvelSignature {
        @Dependency(\.dateProvider) var dateProvider
        
        return GenerateMarvelSignature(
            generator: .testValue,
            date: dateProvider.generate(),
            apiKey: AppConfig.publicKey,
            privateKey: AppConfig.privateKey
        )
    }
}
public extension DependencyValues {
    var signature: GenerateMarvelSignature {
        get { self[GenerateMarvelSignature.self] }
        set { self[GenerateMarvelSignature.self] = newValue }
    }
}
