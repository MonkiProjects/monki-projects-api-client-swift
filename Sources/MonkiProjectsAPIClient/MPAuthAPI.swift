//
//  MPAuthAPI.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 02/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel

public final class MPAuthAPI: API, ObservableObject {
	
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
	
	public func logIn(username: String, password: String) -> Publisher<User.Token.Private> {
		return dataLoader.request(endpoints.logIn(), beforeRequest: { req in
			req.setBasicAuth(username: username, password: password)
		})
	}
	
	public func getMe() -> Publisher<User.Private> {
		return authenticatedRequest(endpoints.getMe())
	}
	
}

extension MPAuthAPI {
	
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
