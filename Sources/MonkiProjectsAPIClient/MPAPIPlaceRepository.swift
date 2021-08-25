//
//  MPAPIPlaceRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 02/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel
import MonkiMapModel

public final class MPAPIPlaceRepository: WebAPI, WebPlacesRepository {
	
	/// # Notes
	///
	/// 1. `Endpoints` are a computed value so that `session.server` is updated when `session` changes
	internal var endpoints: Endpoints { Endpoints(server: session.server) }
	
	public let session: WebAPISession
	public lazy var encoder = MonkiProjectsAPIs.encoder
	public lazy var decoder = MonkiProjectsAPIs.decoder
	
	public init(session: WebAPISession) {
		self.session = session
	}
	
	// MARK: - Combine Publishers
	
	public func listPlaces(page: PageRequest? = nil) -> AnyPublisher<Page<Place.Public>, Error> {
		return self.authenticatedRequest(endpoints.listPlaces(page: page))
	}
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func listPlaces(page: PageRequest? = nil) async throws -> Page<Place.Public> {
		return try await self.authenticatedRequest(endpoints.listPlaces(page: page))
	}
	
}

extension MPAPIPlaceRepository {
	
	internal struct Endpoints: APIEndpoints {
		
		let server: APIServer
		
		func listPlaces(page: PageRequest? = nil) -> Endpoint {
			return self.get("/places/v1", queryItems: page.queryItems)
		}
		
	}
	
}
