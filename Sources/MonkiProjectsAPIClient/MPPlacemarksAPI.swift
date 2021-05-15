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
	
	internal var endpoints: Endpoints { Endpoints(root: root) }
	
	public var decoder: JSONDecoder { MonkiProjectsAPI.decoder }
	public var dataLoader: DataLoader { DataLoader(decoder: decoder) }
	
	public let root: APIRoot
	public var auth: HTTPAuthentication?
	
	public init(root: APIRoot, auth: HTTPAuthentication? = nil) {
		self.root = root
		self.auth = auth
	}
	
	public func listPlacemarks(
		state: Placemark.State? = nil,
		page: PageRequest
	) -> Publisher<Page<Placemark.Public>> {
		return self.authenticatedRequest(endpoints.listPlacemarks(state: state, page: page))
	}
	
}

extension MPPlacemarksAPI {
	
	internal struct Endpoints: APIEndpoints {
		
		let root: APIRoot
		
		func listPlacemarks(
			state: Placemark.State? = nil,
			page: PageRequest
		) -> Endpoint {
			return self.get(
				"abc",
				queryItems: [.init(name: "state", value: state?.rawValue)] + page.queryItems
			)
		}
		
	}
	
}
