import Dependencies
import HorizonNetwork

struct HeroDetailsRemoteDataSource {
    let fetchHeroDetails: @Sendable (_ heroId: Int, _ type: ResourceSection) async throws -> Response<ResourcesDTO>
}

extension HeroDetailsRemoteDataSource: DependencyKey {
    static var liveValue: Self {
        HeroDetailsRemoteDataSource(fetchHeroDetails: { heroId, type in
            try await NetworkApi.request(
                MarvelServices(
                    requestConfiguration: RequestConfiguration(
                        method: .get,
                        path: "characters/\(heroId)/\(type.rawValue)",
                        parameters: nil,
                        encoding: .urlEncoding
                    )
                )
            )
        })
    }
}

extension HeroDetailsRemoteDataSource: TestDependencyKey {
    static var testValue: Self {
        HeroDetailsRemoteDataSource(
            fetchHeroDetails: { _, _ in
                Response<ResourcesDTO>(
                    code: 1,
                    status: "Success",
                    copyright: "",
                    attributionText: "",
                    attributionHTML: "",
                    etag: "",
                    data: .mock
                )
        })
    }

    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var heroDetailsRemoteDataSource: HeroDetailsRemoteDataSource {
    get { self[HeroDetailsRemoteDataSource.self] }
    set { self[HeroDetailsRemoteDataSource.self] = newValue }
  }
}
