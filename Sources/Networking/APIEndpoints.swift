//
//  APIEndpoints.swift
//  Networking
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation

public protocol APIEndpoints {
	var server: APIServer { get }
}

extension APIEndpoints {
	
	public func get(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(server: self.server, method: .get, path: path, queryItems: queryItems)
	}
	
	public func post(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(server: self.server, method: .post, path: path, queryItems: queryItems)
	}
	
	public func put(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(server: self.server, method: .put, path: path, queryItems: queryItems)
	}
	
	public func patch(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(server: self.server, method: .patch, path: path, queryItems: queryItems)
	}
	
	public func delete(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(server: self.server, method: .delete, path: path, queryItems: queryItems)
	}
	
}
