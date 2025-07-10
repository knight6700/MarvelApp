import SwiftUI
import HorizonComponent
import ComposableArchitecture

@Reducer
public struct ResourceGridRowFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: Int {
            resource.id
        }
        let resource: ResourceItem
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case rowDidTapped(URL?)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { _, _ in
            return .none
        }
    }
}

struct ResourceGridRowView: View {

    @Bindable var store: StoreOf<ResourceGridRowFeature>
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ImageView(
                url: store.resource.imageURL,
                size: CGSize(width: 100, height: 200),
                placeholder: .placeholder
            )
            .fixedSize(horizontal: false, vertical: true)
            VStack(alignment: .leading, spacing: 8) {
                Text(store.resource.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.50)
                Text(store.resource.description ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            store.send(.rowDidTapped(store.resource.resourceURL))
        }
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#if DEBUG
#Preview {
    ResourceGridRowView(
        store: Store(
            initialState: ResourceGridRowFeature.State(
                resource: ResourceItem(
                    id: 1,
                    imageURL: .staticImage,
                    resourceURL: URL(string: "https://example.com/comic/1"),
                    name: "A-Bomb (HAS)",
                    description: "Rick Jones has been Hulk's best bud since day one!",
                    price: []
                )
            ),
            reducer: {
                ResourceGridRowFeature()
            }
        )
    )
    .padding()
}
#endif
