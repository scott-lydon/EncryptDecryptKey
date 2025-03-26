// swift-tools-version: 5.09
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "EncryptDecryptKey",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "EncryptDecryptKey",
            targets: ["EncryptDecryptKey"]
        ),
    ],
    dependencies: [
        // ✅ Added swift-crypto
        .package(url: "https://github.com/apple/swift-crypto.git", .upToNextMajor(from: "3.12.2"))
    ],
    targets: [
        .target(
            name: "EncryptDecryptKey",
            dependencies: [
                // ✅ Link Crypto to the target
                .product(name: "Crypto", package: "swift-crypto")
            ]
        ),
        .testTarget(
            name: "EncryptDecryptKeyTests",
            dependencies: ["EncryptDecryptKey"]
        ),
    ]
)
