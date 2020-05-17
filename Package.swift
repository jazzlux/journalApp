// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Hey",
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),

        // 🍃 An expressive, performant, and extensible templating language built for Swift.
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0"),
        //MySQL driver
        .package(url: "https://github.com/vapor/fluent-mysql-driver", from: "3.0.0"),
        // 👤 Authentication and Authorization framework for Fluent.
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0"),
        .package(url: "https://github.com/skelpo/JWTMiddleware.git", from: "0.6.1")
         ],
    targets: [
        .target(name: "App", dependencies: ["Leaf", "Vapor", "FluentMySQL", "Authentication", "JWTMiddleware"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

