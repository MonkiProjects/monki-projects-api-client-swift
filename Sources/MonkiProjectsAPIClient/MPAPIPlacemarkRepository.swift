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

public final class MPAPIPlacemarkRepository: API, WebPlacemarksRepository, ObservableObject {
	
	internal lazy var endpoints = Endpoints(server: server)
	
	public let session: URLSession
	public lazy var encoder = MonkiProjectsAPIs.encoder
	public lazy var decoder = MonkiProjectsAPIs.decoder
	
	public let server: APIServer
	@Published public var auth: HTTPAuthentication?
	
	public init(server: APIServer, session: URLSession, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.session = session
		self.auth = auth
	}
	
	public func listPlacemarks(
		state: Placemark.State? = nil,
		page: PageRequest? = nil
	) -> AnyPublisher<Page<Placemark.Public>, Error> {
		return self.authenticatedRequest(endpoints.listPlacemarks(state: state, page: page))
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
