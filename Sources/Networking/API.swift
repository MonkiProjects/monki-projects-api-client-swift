//
//  API.swift
//  Networking
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine

public protocol API {
	
	var session: URLSession { get }
	
	var encoder: JSONEncoder { get }
	var decoder: JSONDecoder { get }
	
	var auth: HTTPAuthentication? { get set }
	
}

extension API {
	
	public var dataLoader: DataLoader { DataLoader(session: self.session, decoder: self.decoder) }
	public var networkManager: NetworkManager { NetworkManager(session: self.session) }
	
	public func authenticatedRequest(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Void, Error> {
		return self.networkManager.request(endpoint, beforeRequest: { req in
			req.applyAuth(self.auth)
			beforeRequest(&req)
		})
	}
	
	public func authenticatedRequest<Input: Encodable>(
		_ endpoint: Endpoint,
		body: Input,
		beforeRequest: @escaping (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Void, Error> {
		Just(body)
			.tryMap { body -> Data in
				try self.encoder.encode(body)
			}
			.flatMap { data in
				self.authenticatedRequest(endpoint, beforeRequest: { req in
					req.httpBody = data
					beforeRequest(&req)
				})
			}
			.eraseToAnyPublisher()
	}
	
	public func authenticatedRequest<Output: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Output, Error> {
		return self.dataLoader.request(endpoint, beforeRequest: { req in
			req.applyAuth(self.auth)
			beforeRequest(&req)
		})
	}
	
	public func authenticatedRequest<Input: Encodable, Output: Decodable>(
		_ endpoint: Endpoint,
		body: Input,
		beforeRequest: @escaping (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Output, Error> {
		Just(body)
			.tryMap { body -> Data in
				try self.encoder.encode(body)
			}
			.flatMap { data in
				self.authenticatedRequest(endpoint, beforeRequest: { req in
					req.httpBody = data
					beforeRequest(&req)
				})
			}
			.eraseToAnyPublisher()
	}
	
}
