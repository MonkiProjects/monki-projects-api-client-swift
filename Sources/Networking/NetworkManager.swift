//
//  NetworkManager.swift
//  Networking
//
//  Created by Rémi Bardon on 10/05/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation
import Combine

public final class NetworkManager {
	
	public let session: URLSession
	
	public init(session: URLSession) {
		self.session = session
	}
	
	public func request(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Void, Error> {
		Just(endpoint)
			.tryMap { (endpoint: Endpoint) -> URLRequest in
				var request = try endpoint.urlRequest()
				beforeRequest(&request)
				return request
			}
			.flatMap { self.execute($0) }
			.eraseToAnyPublisher()
	}
	
	public func execute(_ request: URLRequest) -> AnyPublisher<Void, Error> {
		return self.session
			.dataTaskPublisher(for: request)
			.map { _ in } // Map `Output` to `Void`
			.mapError { $0 } // Map `URLError` to `Error`
			.eraseToAnyPublisher()
	}
	
}
