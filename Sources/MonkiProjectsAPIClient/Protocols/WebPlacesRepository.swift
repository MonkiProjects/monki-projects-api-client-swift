//
//  WebPlacesRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 01/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import Networking
import MonkiProjectsModel
import MonkiMapModel

public protocol WebPlacesRepository: AnyObject, WebAPI {
	
	// MARK: - Combine Publishers
	
	func listPlaces(page: PageRequest?) -> AnyPublisher<Page<Place.Public>, Error>
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func listPlaces(page: PageRequest?) async throws -> Page<Place.Public>
	
}

// MARK: - Functions with default parameters

extension WebPlacesRepository {
	
	public func listPlaces() -> AnyPublisher<Page<Place.Public>, Error> {
		return self.listPlaces(page: nil)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func listPlaces() async throws -> Page<Place.Public> {
		return try await self.listPlaces(page: nil)
	}
	
}
