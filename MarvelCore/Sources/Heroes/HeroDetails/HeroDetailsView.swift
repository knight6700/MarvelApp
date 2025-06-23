import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct HeroDetailsFeature {
    @ObservableState
    public struct State: Equatable {
        var sections: ResourcesSectionsFeature.State
        let hero: Hero?
        var showSafari: Bool = false
        var resourceURL: URL?
    }
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case sections(ResourcesSectionsFeature.Action)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case let .sections(.rows(.element(_, action: .resources(.resourceDetailsRows(.element(id: _, action: .rowDidTapped(url))))))):
                state.resourceURL = url
                state.showSafari = true
                return .none
            case .sections, .binding:
                return .none
            }
        }
        Scope(
            state: \.sections,
            action: \.sections,
            child: {
                ResourcesSectionsFeature()
            }
        )
    }
}

struct HeroDetailsView: View {
    @Bindable var store: StoreOf<HeroDetailsFeature>

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack(spacing: 20) {
                    if let hero = store.hero {
                        HeroHeaderView(hero: hero)
                            .accessibilityLabel("Hero-Header")
                    }
                    ResourceSectionsView(store: store.scope(state: \.sections, action: \.sections))
                        .frame(height: geo.size.height + 200)
                }
                .padding()
            }
        }
        .sheet(isPresented: $store.showSafari) {
            if let url = store.resourceURL {
                SafariView(url: url)
            }
        }
    }
}

#Preview {
    HeroDetailsView(
        store: Store(
            initialState: HeroDetailsFeature.State(
                sections: ResourcesSectionsFeature.State(
                    rows: [
                        ResourceSectionFeature.State(
                            sectionType: .comics,
                            resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                            heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                            heroId: 1
                        ),
                        ResourceSectionFeature.State(
                            sectionType: .series,
                            resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                            heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                            heroId: 2
                        ),
                        ResourceSectionFeature.State(
                            sectionType: .stories,
                            resources: ResourceGridRowsFeature.State(resourceDetailsRows: .mock),
                            heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                            heroId: 3
                        )
                    ]
                ),
                hero: Hero(
                    id: "0",
                    heroId: 0,
                    imageURL: nil,
                    name: "Fares",
                    shortDescription: "Fares Junior"
                )
            ),
            reducer: {
                HeroDetailsFeature()
            }
        )
    )
}
