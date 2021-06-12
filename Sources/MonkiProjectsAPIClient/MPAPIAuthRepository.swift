//
//  MPAPIAuthRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 02/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel

public final class MPAPIAuthRepository: WebAPI, WebAuthRepository {
	
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
	
	public func logIn(username: String, password: String) -> AnyPublisher<User.Token.Private, Error> {
		return dataLoader.request(endpoints.logIn(), beforeRequest: { req in
			req.setBasicAuth(username: username, password: password)
		})
	}
	
	public func getMe() -> AnyPublisher<User.Private, Error> {
		return authenticatedRequest(endpoints.getMe())
	}
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func logIn(username: String, password: String) async throws -> User.Token.Private {
		return try await dataLoader.request(endpoints.logIn(), beforeRequest: { req in
			req.setBasicAuth(username: username, password: password)
		})
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func getMe() async throws -> User.Private {
		return try await authenticatedRequest(endpoints.getMe())
	}
	
}

extension MPAPIAuthRepository {
	
	internal struct Endpoints: APIEndpoints {
		
		let server: APIServer
		
		func logIn() -> Endpoint {
			return self.post("/auth/v1/login")
		}
		
		func getMe() -> Endpoint {
			return self.get("/auth/v1/me")
		}
		
	}
	
}
