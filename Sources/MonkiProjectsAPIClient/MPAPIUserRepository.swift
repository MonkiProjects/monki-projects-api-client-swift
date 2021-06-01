//
//  MPAPIUserRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 22/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel

public final class MPAPIUserRepository: API, WebUserRepository, ObservableObject {
	
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
	
	public func listUsers(page: PageRequest? = nil) -> AnyPublisher<Page<User.Public.Small>, Error> {
		return self.authenticatedRequest(endpoints.listUsers(page: page))
	}
	
	public func createUser(_ create: User.Create) -> AnyPublisher<User.Private, Error> {
		return self.authenticatedRequest(endpoints.createUser(), body: create)
	}
	
	public func getUser(_ userId: UUID) -> AnyPublisher<User.Public.Full, Error> {
		return self.authenticatedRequest(endpoints.getUser(userId))
	}
	
	public func updateUser(_ userId: UUID, with update: User.Update) -> AnyPublisher<User.Public.Full, Error> {
		return self.authenticatedRequest(endpoints.updateUser(userId), body: update)
	}
	
	public func deleteUser(_ userId: UUID) -> AnyPublisher<Void, Error> {
		return self.authenticatedRequest(endpoints.deleteUser(userId))
	}
	
}

extension MPAPIUserRepository {
	
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
