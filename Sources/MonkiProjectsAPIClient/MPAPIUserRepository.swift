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

public final class MPAPIUserRepository: WebAPI, WebUserRepository {
	
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
