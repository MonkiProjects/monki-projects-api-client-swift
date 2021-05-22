//
//  MPPlacemarksAPI.swift
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

public struct MPPlacemarksAPI: API {
	
	public typealias Publisher<T> = AnyPublisher<T, Error>
	
	internal var endpoints: Endpoints { Endpoints(server: server) }
	
	public var encoder: JSONEncoder { MonkiProjectsAPI.encoder }
	public var decoder: JSONDecoder { MonkiProjectsAPI.decoder }
	public var dataLoader: DataLoader { DataLoader(decoder: decoder) }
	
	public let server: APIServer
	public var auth: HTTPAuthentication?
	
	public init(server: APIServer, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.auth = auth
	}
	
	public func listPlacemarks(
		state: Placemark.State? = nil,
		page: PageRequest? = nil
	) -> Publisher<Page<Placemark.Public>> {
		return self.authenticatedRequest(endpoints.listPlacemarks(state: state, page: page))
	}
	
}

extension MPPlacemarksAPI {
	
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
