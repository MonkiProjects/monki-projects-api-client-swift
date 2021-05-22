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

public struct MPAuthAPI: API {
	
	public typealias Publisher<T> = AnyPublisher<T, Error>
	
	internal var endpoints: Endpoints { Endpoints(server: server) }
	
	public var decoder: JSONDecoder { MonkiProjectsAPI.decoder }
	public var dataLoader: DataLoader { DataLoader(decoder: decoder) }
	
	public let server: APIServer
	public var auth: HTTPAuthentication?
	
	public init(server: APIServer, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.auth = auth
	}
	
	public func logIn(username: String, password: String) -> Publisher<User.Token.Private> {
		return dataLoader.request(endpoints.logIn(), beforeRequest: { req in
			req.setBasicAuth(username: username, password: password)
		})
	}
	
}

extension MPAuthAPI {
	
	internal struct Endpoints: APIEndpoints {
		
		let server: APIServer
		
		func logIn() -> Endpoint {
			return self.get("/auth/v1/login")
		}
		
	}
	
}
