import Dependencies
import Foundation
import IdentifiedCollections

struct HeroDataProcessingUseCase {
    let processHeroData: @Sendable (_ heroes: [Hero]) -> ProcessedHeroData
    let generateSearchSuggestions: @Sendable (_ heroes: [Hero]) -> [SearchSuggestions]
}

struct ProcessedHeroData {
    let heroStates: [HeroListRowFeature.State]
    let searchSuggestions: [SearchSuggestions]
}

extension HeroDataProcessingUseCase: DependencyKey {
    static var liveValue: Self {
        HeroDataProcessingUseCase(
            processHeroData: { heroes in
                let heroStates =  heroes.map {
                    HeroListRowFeature.State(hero: $0)
                }
                
                let suggestions = heroes.map {
                    hero in SearchSuggestions(id: hero.heroId, name: hero.name)
                }
                return ProcessedHeroData(
                    heroStates: heroStates,
                    searchSuggestions: suggestions
                )
            },
            generateSearchSuggestions: { heroes in
                heroes.compactMap { hero in
                    guard !hero.name.isEmpty else { return nil }
                    return SearchSuggestions(id: hero.heroId, name: hero.name)
                }
            }
        )
    }
}

extension HeroDataProcessingUseCase: TestDependencyKey {
    static var previewValue: Self {
        HeroDataProcessingUseCase(
            processHeroData: { _ in
                ProcessedHeroData(
                    heroStates: .mock,
                    searchSuggestions: .mock
                )
            },
            generateSearchSuggestions: { heroes in
                heroes.compactMap { hero in
                    guard !hero.name.isEmpty else { return nil }
                    return SearchSuggestions(id: hero.heroId, name: hero.name)
                }
            }
        )
    }
}

extension DependencyValues {
    var heroDataProcessingUseCase: HeroDataProcessingUseCase {
        get { self[HeroDataProcessingUseCase.self] }
        set { self[HeroDataProcessingUseCase.self] = newValue }
    }
}
