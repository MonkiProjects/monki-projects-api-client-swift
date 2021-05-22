//
//  MPUsersAPI.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 22/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel

public struct MPUsersAPI: API {
	
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
	
	public func listUsers(page: PageRequest? = nil) -> Publisher<Page<User.Public.Small>> {
		return self.authenticatedRequest(endpoints.listUsers(page: page))
	}
	
	public func createUser(_ create: User.Create) -> Publisher<Page<User.Public.Small>> {
		return self.authenticatedRequest(endpoints.createUser(), body: create)
	}
	
}

extension MPUsersAPI {
	
	internal struct Endpoints: APIEndpoints {
		
		let server: APIServer
		
		func listUsers(page: PageRequest? = nil) -> Endpoint {
			return self.get("/users/v1", queryItems: page.queryItems)
		}
		
		func createUser() -> Endpoint {
			return self.post("/users/v1")
		}
		
	}
	
}
