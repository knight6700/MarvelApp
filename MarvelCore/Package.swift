// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private let packageDependencies: [Package.Dependency] = [
    .package(
        url: "https://github.com/pointfreeco/swift-composable-architecture",
        from: "1.17.1"
    ),
    .package(
        url: "https://github.com/pointfreeco/swift-snapshot-testing",
        from: "1.16.0"
    ),
    .package(
        url: "https://github.com/onevcat/Kingfisher",
        from: "8.1.1"
    ),
    .package(path: "../../ArkanaKeys/HorizonKeys"),
]

private let products: [Product] = [
    .library(
        name: "Heroes",
        targets: ["Heroes"]
    ),
    .library(
        name: "HorizonComponent",
        targets: ["HorizonComponent"]
    ),
    .library(
        name: "HorizonNetwork",
        targets: ["HorizonNetwork"]
    ),
]

private let NETWORK: Target.Dependency = "HorizonNetwork"
private let SnapshotTesting: Target.Dependency = .product(
    name: "SnapshotTesting",
    package: "swift-snapshot-testing"
)
private let TCADependency: Target.Dependency = .product(
    name: "ComposableArchitecture",
    package: "swift-composable-architecture"
)
private let heroes: Target.Dependency = "Heroes"
private let horizonComponent: Target.Dependency = "HorizonComponent"
private let horizonKeys: Target.Dependency = .product(
    name: "HorizonKeys",
    package: "HorizonKeys"
)
private let kingFisher: Target.Dependency = .product(
    name: "Kingfisher",
    package: "Kingfisher"
)

let package = Package(
    name: "MarvelCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v12)
    ],
    products: products,
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "Heroes",
            dependencies: [
                TCADependency,
                horizonComponent,
                NETWORK,
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
        ),
        .target(
            name: "HorizonNetwork",
            dependencies: [
                horizonKeys,
                TCADependency,
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
        ),
        .target(
            name: "HorizonComponent",
            dependencies: [
                kingFisher,
            ],
            resources: [
                .copy("Resources/Icons/Images.xcassets"),
                .copy("Resources/Colors/Colors.xcassets"),
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ],
        ),
        .testTarget(
            name: "MarvelSnapshotTests",
            dependencies: [
                heroes,
                horizonComponent,
                TCADependency,
                SnapshotTesting,
            ],
        ),
        .testTarget(
            name: "MarvelCoreTests",
            dependencies: [
                heroes,
                TCADependency,
                NETWORK,
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)