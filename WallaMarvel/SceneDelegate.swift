import UIKit
import netfox
import SwiftUI
import ComposableArchitecture
import Heroes

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        startMentoring()
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let view = HeroCoordinatorFeatureRouterView(
            store: Store(
                initialState: HeroCoordinatorFeature.State(
                    root: HeroListFeature.State(
                        heroes: [],
                        repositoryState: HeroUseCaseFeature.State()
                    )
                ),
                reducer: {
                    HeroCoordinatorFeature()
                }
            )
        )
        let listHeroesViewController = UIHostingController(rootView: view)
        window.rootViewController = listHeroesViewController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    func startMentoring() {
        #if DEBUG
        NFX.sharedInstance().start()
        #endif
    }
}
