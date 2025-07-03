import Foundation
import ComposableArchitecture
@testable import Heroes
import Testing
import HorizonNetwork

@MainActor
struct HeroListFeatureTests {
    @Test("Test fetch heroes with success state")
    func testFetchHeroesWithSuccessState() async {
        let store = TestStore(
            initialState: HeroListFeature.State(heroes: [], repositoryState: HeroUseCaseFeature.State())) {
            HeroListFeature()
          } withDependencies: {
              $0.heroRemoteDataSource = .testValue
              $0.uuid = .incrementing
              
        }
        await store.send(.task)
        await store.receive(.repository(.fetchHeroes(name: nil, isRefreshable: true))) {
            $0.isLoading = false
            $0.repositoryState = HeroUseCaseFeature.State(offset: 0, total: 0)
        }
        await store.receive(.repository(.delegate(.showLoader(true))))
        await store.receive(.viewState(.showLoader(true))) {
            $0.isLoading = true
        }
        await store.receive(.repository(.response(.success(.mock), 3))) {
            $0.repositoryState.total = 3
        }
        await store.receive(.repository(.delegate(.model(.mock)))) {
            $0.heroes = IdentifiedArray(uniqueElements: [HeroListRowFeature.State].mock)
            $0.suggestNames = IdentifiedArray(uniqueElements: [SearchSuggestions].mock)
            $0.filteredSuggestions = [SearchSuggestions].mock
        }
        await store.receive(.repository(.delegate(.showLoader(false))))
        await store.receive(.viewState(.showLoader(false))) {
            $0.isLoading = false
        }
        // Test Search with no match
        await store.send(.binding(.set(\.searchText, "Fares Hero"))) {
            $0.searchText = "Fares Hero"
            $0.filteredSuggestions = []
        }
        await store.receive(.filter)

        // Test Search with data
        await store.send(.binding(.set(\.searchText, "Captain America"))) {
            $0.searchText = "Captain America"
            $0.filteredSuggestions = [SearchSuggestions(id: 2, name: "Captain America")]
        }
        await store.receive(.filter)
    }

    @Test("Test fetch heroes with error state")
    func testFetchHeroesWithErrorState() async {
        let store = TestStore(
            initialState: HeroListFeature.State(heroes: [], repositoryState: HeroUseCaseFeature.State())) {
            HeroListFeature()
          } withDependencies: {
              $0.heroRemoteDataSource = .failValue
        }
        await store.send(.task)
        await store.receive(.repository(.fetchHeroes(name: nil, isRefreshable: true))) {
            $0.isLoading = false
            $0.repositoryState = HeroUseCaseFeature.State(offset: 0, total: 0)
        }
        await store.receive(.repository(.delegate(.showLoader(true))))
        await store.receive(.viewState(.showLoader(true))) {
            $0.isLoading = true
        }
        await store.receive(.repository(.response(.failure(.badRequest), 0)))
        await store.receive(.repository(.delegate(.showErrorMessage("Something went to wrong"))))
        await store.receive(.viewState(.showErrorMessage("Something went to wrong"))) {
            $0.isLoading = false
            $0.errorMessage = "Something went to wrong"
        }
    }
}
