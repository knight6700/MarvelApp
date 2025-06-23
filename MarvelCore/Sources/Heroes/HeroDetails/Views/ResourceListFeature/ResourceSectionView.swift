import SwiftUI
import HorizonNetwork
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct ResourceSectionFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: String {
            sectionType.rawValue
        }

        let sectionType: ResourceSection
        var resources: ResourceGridRowsFeature.State
        var heroDetailsRepository: HeroDetailsUseCaseFeature.State
        var isLoading: Bool = false
        var errorMessage: String?
        let heroId: Int
        init(
            sectionType: ResourceSection,
            resources: ResourceGridRowsFeature.State,
            heroDetailsRepository: HeroDetailsUseCaseFeature.State,
            heroId: Int
        ) {
            self.sectionType = sectionType
            self.resources = resources
            self.heroDetailsRepository = heroDetailsRepository
            self.heroId = heroId
        }
    }

    @Dependency(\.resourceMapper) var resourceMapper

    public enum Action: Equatable, BindableAction {
        case resources(ResourceGridRowsFeature.Action)
        case heroDetailsRepository(HeroDetailsUseCaseFeature.Action)
        case binding(BindingAction<State>)
        case task
        case viewSate(ViewSate)
    }

    public enum ViewSate: Equatable {
        case showLoader(isLoading: Bool)
        case showErrorMessage(message: String?)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .task:
                return .send(.heroDetailsRepository(.fetch(heroId: state.heroId, sectionType: state.sectionType)))
            case .resources:
                return .none
            case let .heroDetailsRepository(.delegate(delegateAction)):
                switch delegateAction {
                case let .model(model):
                    let resources = resourceMapper.toDomain(model)
                    state.resources = resources
                    return .send(.viewSate(.showLoader(isLoading: false)))
                case let .showLoader(isLoading):
                    return .send(.viewSate(.showLoader(isLoading: isLoading)))
                case let .showErrorMessage(errorMessage):
                    return .send(.viewSate(.showErrorMessage(message: errorMessage)))
                }
            case .heroDetailsRepository, .binding:
                return .none
            case let .viewSate(viewSate):
                switch viewSate {
                case let .showLoader(isLoading):
                    state.isLoading = isLoading
                case let .showErrorMessage(errorMessage):
                    state.isLoading = false
                    state.errorMessage = errorMessage
                }
                return .none
            }
        }
        Scope(
            state: \.heroDetailsRepository,
            action: \.heroDetailsRepository
        ) {
            HeroDetailsUseCaseFeature()
        }
    }
}

struct ResourceSectionView: View {

   @Bindable var store: StoreOf<ResourceSectionFeature>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(store.sectionType.title)
                Spacer()
                Button("See All") {
                    // TODO: - Handle See All
                }
            }
            ResourceGridRowsView(
                store: store.scope(
                    state: \.resources,
                    action: \.resources
                )
            )
            .loadingErrorOverlay(
                isLoading: $store.isLoading,
                error: $store.errorMessage
            ) {
                 store.send(.task, animation: .smooth)
            }
            .task {
                await store.send(.task, animation: .smooth).finish()
            }
        }
    }
}

#if DEBUG
#Preview {
    GeometryReader { _ in
        ScrollView {
            ResourceSectionView(
                store: Store(
                    initialState: ResourceSectionFeature.State(
                        sectionType: .stories,
                        resources: ResourceGridRowsFeature.State(
                            resourceDetailsRows: .mock
                        ),
                        heroDetailsRepository: HeroDetailsUseCaseFeature.State(),
                        heroId: 0
                    ),
                    reducer: { ResourceSectionFeature()
                    }
                )
            )
            .padding()
        }
    }
}
#endif
