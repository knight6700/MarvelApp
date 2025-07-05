import Dependencies
import Foundation
import HorizonNetwork

struct HeroMapper {
    let toDomain: @Sendable (_ dto: [HeroResult], _ id: String) -> [Hero]
}

extension HeroMapper: DependencyKey {
    static var liveValue: Self {
        return HeroMapper(
            toDomain: { dto, id in
                dto.map {
                    Hero(
                        id: id, // to resolve duplicated id from api
                        heroId: $0.id,
                        imageURL: ThumbnailURLBuilder(thumbnail: $0.thumbnail).build(),
                        name: $0.name,
                        shortDescription: $0.description
                    )
                }
            }
        )
    }
}
extension HeroMapper: TestDependencyKey {
    static var testValue: Self {
        return .liveValue
    }
    
    static var previewValue: Self {
        .testValue
    }
}
extension DependencyValues {
    var heroMapper: HeroMapper {
    get { self[HeroMapper.self] }
    set { self[HeroMapper.self] = newValue }
  }
}
