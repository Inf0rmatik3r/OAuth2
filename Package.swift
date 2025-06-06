// swift-tools-version:5.3
//
//  Package.swift
//  OAuth2
//
//  Created by Pascal Pfiffner on 12/19/15.
//  Copyright 2015 Pascal Pfiffner
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import PackageDescription

let package = Package(
	name: "OAuth2",
	platforms: [
		.macOS(.v10_15), .iOS(.v12), .tvOS(.v12), .watchOS(.v5)
	],
	products: [
		.library(name: "OAuth2", targets: ["OAuth2"]),
	],
	dependencies: [
		// SwiftKeychain is not yet available as a Package, so we symlink to /Sources and make it a Target
		//.package(url: "https://github.com/yankodimitrov/SwiftKeychain.git", majorVersion: 1),
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "5.0.0"),
	],
	targets: [
		.target(name: "OAuth2",
			dependencies: ["Base", "Flows", "DataLoader"]),
        .target(name: "Base", dependencies: [.product(name: "Crypto", package: "swift-crypto"), .product(name: "_CryptoExtras", package: "swift-crypto")]),
		.target(name: "macOS", dependencies: [.target(name: "Base")]),
		.target(name: "iOS", dependencies: [.target(name: "Base")]),
		.target(name: "tvOS", dependencies: [.target(name: "Base")]),
		.target(name: "Flows", dependencies: [
			.target(name: "macOS"), .target(name: "iOS"), .target(name: "tvOS")]),
		.target(name: "DataLoader", dependencies: [.target(name: "Flows")]),
		.testTarget(name: "BaseTests", dependencies: [.target(name: "Base"), .target(name: "Flows")]),
		.testTarget(name: "FlowTests", dependencies: [.target(name: "Flows")]),
//		.testTarget(name: "DataLoaderTests", dependencies: [.target(name: "DataLoader")]),
	]
)
