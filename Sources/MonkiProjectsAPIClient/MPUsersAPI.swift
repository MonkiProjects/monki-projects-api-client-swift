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

public final class MPUsersAPI: API, ObservableObject {
	
	public typealias Publisher<T> = AnyPublisher<T, Error>
	
	internal lazy var endpoints = Endpoints(server: server)
	
	public lazy var encoder = MonkiProjectsAPIs.encoder
	public lazy var decoder = MonkiProjectsAPIs.decoder
	public lazy var dataLoader = DataLoader(decoder: decoder)
	
	public let server: APIServer
	@Published public var auth: HTTPAuthentication?
	
	public init(server: APIServer, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.auth = auth
	}
	
	public func listUsers(page: PageRequest? = nil) -> Publisher<Page<User.Public.Small>> {
		return self.authenticatedRequest(endpoints.listUsers(page: page))
	}
	
	public func createUser(_ create: User.Create) -> Publisher<User.Private> {
		return self.authenticatedRequest(endpoints.createUser(), body: create)
	}
	
	public func getUser(_ userId: UUID) -> Publisher<User.Public.Full> {
		return self.authenticatedRequest(endpoints.getUser(userId))
	}
	
	public func updateUser(_ userId: UUID, with update: User.Update) -> Publisher<User.Public.Full> {
		return self.authenticatedRequest(endpoints.updateUser(userId), body: update)
	}
	
	public func deleteUser(_ userId: UUID) -> Publisher<Void> {
		return self.authenticatedRequest(endpoints.deleteUser(userId))
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
		
		func getUser(_ userId: UUID) -> Endpoint {
			return self.get("/users/v1/\(userId)")
		}
		
		func updateUser(_ userId: UUID) -> Endpoint {
			return self.patch("/users/v1/\(userId)")
		}
		
		func deleteUser(_ userId: UUID) -> Endpoint {
			return self.delete("/users/v1/\(userId)")
		}
		
	}
	
}
