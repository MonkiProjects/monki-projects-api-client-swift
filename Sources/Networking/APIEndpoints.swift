//
//  APIEndpoints.swift
//  Networking
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation

public protocol APIEndpoints {
	var root: APIRoot { get }
}

extension APIEndpoints {
	
	public func get(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(root: self.root, method: .get, path: path, queryItems: queryItems)
	}
	
	public func post(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(root: self.root, method: .post, path: path, queryItems: queryItems)
	}
	
	public func put(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(root: self.root, method: .put, path: path, queryItems: queryItems)
	}
	
	public func patch(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(root: self.root, method: .patch, path: path, queryItems: queryItems)
	}
	
	public func delete(_ path: String, queryItems: [URLQueryItem] = []) -> Endpoint {
		return Endpoint(root: self.root, method: .delete, path: path, queryItems: queryItems)
	}
	
}
