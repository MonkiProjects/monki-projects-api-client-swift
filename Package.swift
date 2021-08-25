// swift-tools-version:5.4

import PackageDescription

let package = Package(
	name: "monki-projects-api-client",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
	],
	products: [
		.library(
			name: "MonkiProjectsAPIClient",
			targets: ["MonkiProjectsAPIClient"]
		)
	],
	dependencies: [
		.package(
			name: "monki-projects-model",
			url: "https://github.com/MonkiProjects/monki-projects-model-swift",
			.upToNextMinor(from: "0.6.0")
		),
	],
	targets: [
		.target(name: "Networking"),
		.target(
			name: "MonkiProjectsAPIClient",
			dependencies: [
				.target(name: "Networking"),
				.product(name: "MonkiProjectsModel", package: "monki-projects-model"),
				.product(name: "MonkiMapModel", package: "monki-projects-model"),
			]
		),
		.testTarget(
			name: "MonkiProjectsAPIClientTests",
			dependencies: [.target(name: "MonkiProjectsAPIClient")]
		),
	]
)
