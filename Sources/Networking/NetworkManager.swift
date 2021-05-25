//
//  NetworkManager.swift
//  Networking
//
//  Created by Rémi Bardon on 10/05/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Combine
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public final class NetworkManager {
	
	// swiftlint:disable type_name
	#if canImport(UIKit)
	public typealias _Image = UIImage
	#elseif canImport(AppKit)
	public typealias _Image = NSImage
	#endif
	// swiftlint:enable type_name
	
	// MARK: Singleton pattern
	
	public static let shared = NetworkManager()
	
	// swiftlint:disable:next type_contents_order
	private init() {}
	
	// MARK: Properties
	
	private let imageCache = NSCache<NSString, _Image>()
	
	// MARK: Methods
	
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
		return URLSession.shared
			.dataTaskPublisher(for: request)
			.map { _ in }
			.mapError { $0 }
			.eraseToAnyPublisher()
	}
	
	public func getImage(at url: URL) -> AnyPublisher<_Image, Error> {
		let cacheKey = NSString(string: url.absoluteString)
		
		if let image = imageCache.object(forKey: cacheKey) {
			return Just(image)
				// Change `Never` Failure type to `Error`
				.tryMap { $0 }
				.eraseToAnyPublisher()
		}
		
		return DataLoader.execute(URLRequest(url: url))
			.tryMap { data -> _Image in
				if let image = _Image(data: data) {
					return image
				} else {
					throw NetworkError.invalidData
				}
			}
			.map { [weak self] image -> _Image in
				self?.imageCache.setObject(image, forKey: cacheKey)
				return image
			}
			.eraseToAnyPublisher()
	}
	
}
