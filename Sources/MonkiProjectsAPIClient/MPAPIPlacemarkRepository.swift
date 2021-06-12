//
//  MPAPIPlacemarkRepository.swift
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

public final class MPAPIPlacemarkRepository: WebAPI, WebPlacemarksRepository {
	
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
	
	public func listPlacemarks(
		state: Placemark.State? = nil,
		page: PageRequest? = nil
	) -> AnyPublisher<Page<Placemark.Public>, Error> {
		return self.authenticatedRequest(endpoints.listPlacemarks(state: state, page: page))
	}
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func listPlacemarks(
		state: Placemark.State? = nil,
		page: PageRequest? = nil
	) async throws -> Page<Placemark.Public> {
		return try await self.authenticatedRequest(endpoints.listPlacemarks(state: state, page: page))
	}
	
}

extension MPAPIPlacemarkRepository {
	
	internal struct Endpoints: APIEndpoints {
		
		let server: APIServer
		
		func listPlacemarks(
			state: Placemark.State? = nil,
			page: PageRequest? = nil
		) -> Endpoint {
			return self.get("/placemarks/v1", queryItems: state.queryItems + page.queryItems)
		}
		
	}
	
}
