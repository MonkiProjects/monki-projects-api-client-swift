//
//  Endpoint.swift
//  Networking
//
//  Created by Rémi Bardon on 03/09/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation

/// Inspired by [Constructing URLs in Swift](https://www.swiftbysundell.com/articles/constructing-urls-in-swift/#endpoints)
public struct Endpoint {
	
	public enum Method: String {
		case get = "GET"
		case post = "POST"
		case put = "PUT"
		case patch = "PATCH"
		case delete = "DELETE"
	}
	
	public let root: APIRoot
	public let method: Method
	public let path: String
	public let queryItems: [URLQueryItem]
	
	/// Constructs the endpoint `URL`.
	///
	/// # Notes
	///
	/// 1. We still have to keep `url` as an optional, since we're
	///    dealing with dynamic components that could be invalid.
	public var url: URL? {
		var components = URLComponents()
		components.scheme = "\(root.scheme)"
		components.host = "\(root.host)"
		components.path = path
		components.queryItems = queryItems
		
		return components.url
	}
	
	public init(
		root: APIRoot,
		method: Method = .get,
		path: String = "/",
		queryItems: [URLQueryItem] = []
	) {
		self.root = root
		self.method = method
		self.path = path
		self.queryItems = queryItems
	}
	
	public func urlRequest() throws -> URLRequest? {
		guard let url = self.url else {
			// Abort if invalid URL
			assertionFailure("Invalid URL")
			throw NetworkError.invalidURL
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = self.method.rawValue
		return request
	}
	
}
