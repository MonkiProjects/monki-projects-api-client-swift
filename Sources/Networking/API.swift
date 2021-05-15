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
	
	var decoder: JSONDecoder { get }
	var dataLoader: DataLoader { get }
	
	var auth: HTTPAuthentication? { get set }
}

extension API {
	
	public func authenticatedRequest<T: Decodable>(
		_ endpoint: Endpoint,
		beforeRequest: (inout URLRequest) -> Void = { _ in }
	) -> AnyPublisher<T, Error> {
		return dataLoader.request(endpoint, beforeRequest: { req in
			req.applyAuth(self.auth)
			beforeRequest(&req)
		})
	}
	
}
