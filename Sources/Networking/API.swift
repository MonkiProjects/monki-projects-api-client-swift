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
	
	var encoder: JSONEncoder { get }
	var decoder: JSONDecoder { get }
	var dataLoader: DataLoader { get }
	
	var auth: HTTPAuthentication? { get set }
	
}

extension API {
	
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
