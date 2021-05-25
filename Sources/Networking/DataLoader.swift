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
	
	public let decoder: JSONDecoder
	
	public init(decoder: JSONDecoder = JSONDecoder()) {
		self.decoder = decoder
	}
	
	// MARK: - Static functions
	
	public static func request(
		_ endpoint: Endpoint,
		with decoder: JSONDecoder = JSONDecoder(),
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Data, Error> {
		Just(endpoint)
			.tryMap { (endpoint: Endpoint) -> URLRequest in
				var request = try endpoint.urlRequest()
				request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
				request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
				beforeRequest(&request)
				return request
			}
			.flatMap { Self.execute($0, with: decoder) }
			.eraseToAnyPublisher()
	}
	
	public static func request<T: Decodable>(
		_ endpoint: Endpoint,
		for type: T.Type,
		with decoder: JSONDecoder = JSONDecoder(),
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return Self.request(endpoint, with: decoder, beforeRequest: beforeRequest)
			.decode(type: type, decoder: decoder)
			.eraseToAnyPublisher()
	}
	
	public static func request<T: Decodable>(
		_ endpoint: Endpoint,
		with decoder: JSONDecoder = JSONDecoder(),
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return Self.request(endpoint, for: T.self, with: decoder, beforeRequest: beforeRequest)
	}
	
	public static func execute(
		_ request: URLRequest,
		with decoder: JSONDecoder = JSONDecoder()
	) -> AnyPublisher<Data, Error> {
		return URLSession.shared
			.dataTaskPublisher(for: request)
			.tryMap { data, response in
				guard let response = response as? HTTPURLResponse else {
					throw NetworkError.invalidResponse
				}
				guard response.statusCode < 400 else {
					throw NetworkError.httpError(code: response.statusCode, message: String(data: data, encoding: .utf8))
				}
				return data
			}
			.eraseToAnyPublisher()
	}
	
	public static func execute<T: Decodable>(
		_ request: URLRequest,
		for type: T.Type,
		with decoder: JSONDecoder = JSONDecoder()
	) -> AnyPublisher<T, Error> {
		return Self.execute(request, with: decoder)
			.decode(type: type, decoder: decoder)
			.eraseToAnyPublisher()
	}
	
	public static func execute<T: Decodable>(
		_ request: URLRequest,
		with decoder: JSONDecoder = JSONDecoder()
	) -> AnyPublisher<T, Error> {
		return Self.execute(request, for: T.self, with: decoder)
	}
	
	// MARK: - Instance functions
	
	public func request(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<Data, Error> {
		Self.request(endpoint, beforeRequest: beforeRequest)
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		for type: T.Type,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		Self.request(endpoint, for: type, with: self.decoder, beforeRequest: beforeRequest)
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		Self.request(endpoint, with: self.decoder, beforeRequest: beforeRequest)
	}
	
	public func execute(_ request: URLRequest) -> AnyPublisher<Data, Error> {
		Self.execute(request)
	}
	
	public func execute<T: Decodable>(_ request: URLRequest, for type: T.Type) -> AnyPublisher<T, Error> {
		Self.execute(request, for: type, with: self.decoder)
	}
	
	public func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		Self.execute(request, for: T.self, with: self.decoder)
	}
	
}
