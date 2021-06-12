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
	
	public func logIn(username: String, password: String) -> AnyPublisher<User.Token.Private, Error> {
		return dataLoader.request(endpoints.logIn(), beforeRequest: { req in
			req.setBasicAuth(username: username, password: password)
		})
	}
	
	public func getMe() -> AnyPublisher<User.Private, Error> {
		return authenticatedRequest(endpoints.getMe())
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
