import Dependencies
import Foundation
import IdentifiedCollections

struct HeroDataProcessingUseCase {
    let processHeroData: @Sendable (_ heroes: [Hero]) -> ProcessedHeroData
    let generateSearchSuggestions: @Sendable (_ heroes: [Hero]) -> [SearchSuggestions]
}

struct ProcessedHeroData {
    let heroStates: IdentifiedArrayOf<HeroListRowFeature.State>
    let searchSuggestions: IdentifiedArrayOf<SearchSuggestions>
}

extension HeroDataProcessingUseCase: DependencyKey {
    static var liveValue: Self {
        HeroDataProcessingUseCase(
            processHeroData: { heroes in
                let heroStates = IdentifiedArray(
                    uniqueElements: heroes.map { HeroListRowFeature.State(hero: $0) }
                )
                
                let suggestions = IdentifiedArray(
                    uniqueElements: heroes.map { hero in
                        SearchSuggestions(id: hero.heroId, name: hero.name)
                    }
                )
                
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
    static var testValue: Self {
        HeroDataProcessingUseCase(
            processHeroData: { _ in
                ProcessedHeroData(
                    heroStates: .mock,
                    searchSuggestions: .mock
                )
            },
            generateSearchSuggestions: { _ in [] }
        )
    }
    
    static var previewValue: Self {
        .testValue
    }
}

extension DependencyValues {
    var heroDataProcessingUseCase: HeroDataProcessingUseCase {
        get { self[HeroDataProcessingUseCase.self] }
        set { self[HeroDataProcessingUseCase.self] = newValue }
    }
}
