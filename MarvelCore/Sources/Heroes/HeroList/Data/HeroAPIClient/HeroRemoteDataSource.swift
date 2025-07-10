import Dependencies
import HorizonNetwork

struct HeroRemoteDataSource {
    let fetchHeroes: @Sendable (_ params: HeroesParams) async throws -> Response<HeroesDTO>
}

extension HeroRemoteDataSource: DependencyKey {
    static var liveValue: Self {
        HeroRemoteDataSource(
            fetchHeroes: { params in
                try await NetworkApi.request(
                    MarvelServices(
                        requestConfiguration: RequestConfiguration(
                            method: .get,
                            path: "characters",
                            parameters: params,
                            encoding: .urlEncoding
                        )
                    )
                )
            }
        )
    }
}

extension HeroRemoteDataSource: TestDependencyKey {
    static var testValue: Self {
        HeroRemoteDataSource(
            fetchHeroes: { _ in
                Response<HeroesDTO>(
                    code: 200,
                    status: "Success",
                    copyright: "",
                    attributionText: "",
                    attributionHTML: "",
                    etag: "",
                    data: .mock
                )
            }
        )
    }
    static var failValue: Self {
        HeroRemoteDataSource(
            fetchHeroes: { _ in
                throw APIError.badRequest
            }
        )
    }
    static var previewValue: Self {
        HeroRemoteDataSource(
            fetchHeroes: { _ in
                Response<HeroesDTO>(
                    code: 200,
                    status: "Success",
                    copyright: "",
                    attributionText: "",
                    attributionHTML: "",
                    etag: "",
                    data: .mock
                )
            }
        )
    }
}

extension DependencyValues {
    var heroRemoteDataSource: HeroRemoteDataSource {
        get { self[HeroRemoteDataSource.self] }
        set { self[HeroRemoteDataSource.self] = newValue }
    }
}
