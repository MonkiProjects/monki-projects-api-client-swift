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
	
	// MARK: - Combine Publishers
	
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
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func request(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) async throws {
		var request = try endpoint.urlRequest()
		beforeRequest(&request)
		return try await self.execute(request)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func execute(_ request: URLRequest) async throws {
		_ = try await self.session.data(for: request)
	}
	
}
