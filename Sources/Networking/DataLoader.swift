//
//  DataLoader.swift
//  Networking
//
//  Created by Rémi Bardon on 03/09/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation
import Combine

public final class DataLoader {
	
	public let session: URLSession
	public let decoder: JSONDecoder
	
	public init(session: URLSession, decoder: JSONDecoder = JSONDecoder()) {
		self.session = session
		self.decoder = decoder
	}
	
	static func assertValidResponse(data: Data, response: URLResponse) throws -> Data {
		guard let response = response as? HTTPURLResponse else {
			throw NetworkError.invalidResponse
		}
		guard response.statusCode < 400 else {
			throw NetworkError.httpError(code: response.statusCode, message: String(data: data, encoding: .utf8))
		}
		return data
	}
	
	// MARK: - Combine Publishers
	
	public func requestForData(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Data, Error> {
		Just(endpoint)
			.tryMap { (endpoint: Endpoint) -> URLRequest in
				var request = try endpoint.urlRequest()
				beforeRequest(&request)
				return request
			}
			.flatMap(self.executeForData)
			.eraseToAnyPublisher()
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		for type: T.Type,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return self.requestForData(endpoint, beforeRequest: beforeRequest)
			.decode(type: type, decoder: self.decoder)
			.eraseToAnyPublisher()
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return self.request(endpoint, for: T.self, beforeRequest: beforeRequest)
	}
	
	public func executeForData(_ request: URLRequest) -> AnyPublisher<Data, Error> {
		return self.session
			.dataTaskPublisher(for: request)
			.tryMap(Self.assertValidResponse)
			.eraseToAnyPublisher()
	}
	
	public func execute<T: Decodable>(_ request: URLRequest, for type: T.Type) -> AnyPublisher<T, Error> {
		return self.executeForData(request)
			.decode(type: type, decoder: self.decoder)
			.eraseToAnyPublisher()
	}
	
	public func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return self.execute(request, for: T.self)
	}
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func requestForData(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) async throws -> Data {
		var request = try endpoint.urlRequest()
		beforeRequest(&request)
		return try await self.execute(request)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		for type: T.Type,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) async throws -> T {
		let data = try await self.requestForData(endpoint, beforeRequest: beforeRequest)
		return try self.decoder.decode(type, from: data)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) async throws -> T {
		return try await self.request(endpoint, for: T.self, beforeRequest: beforeRequest)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func executeForData(_ request: URLRequest) async throws -> Data {
		let (data, response) = try await self.session.data(for: request)
		return try Self.assertValidResponse(data: data, response: response)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func execute<T: Decodable>(_ request: URLRequest, for type: T.Type) async throws -> T {
		let data = try await self.executeForData(request)
		return try self.decoder.decode(type, from: data)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func execute<T: Decodable>(_ request: URLRequest) async throws -> T {
		return try await self.execute(request, for: T.self)
	}
	
}
