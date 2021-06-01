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
	
	public func request(
		_ endpoint: Endpoint,
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
			.flatMap(self.execute)
			.eraseToAnyPublisher()
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		for type: T.Type,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return self.request(endpoint, beforeRequest: beforeRequest)
			.decode(type: type, decoder: self.decoder)
			.eraseToAnyPublisher()
	}
	
	public func request<T: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return self.request(endpoint, for: T.self, beforeRequest: beforeRequest)
	}
	
	public func execute(_ request: URLRequest) -> AnyPublisher<Data, Error> {
		return self.session
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
	
	public func execute<T: Decodable>(_ request: URLRequest, for type: T.Type) -> AnyPublisher<T, Error> {
		return self.execute(request)
			.decode(type: type, decoder: self.decoder)
			.eraseToAnyPublisher()
	}
	
	public func execute<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
		return self.execute(request, for: T.self)
	}
	
}
