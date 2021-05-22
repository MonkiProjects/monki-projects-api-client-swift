//
//  MPUsersAPI.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 22/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import Combine
import MonkiProjectsModel

public struct MPUsersAPI: API {
	
	public typealias Publisher<T> = AnyPublisher<T, Error>
	
	internal var endpoints: Endpoints { Endpoints(root: root) }
	
	public var decoder: JSONDecoder { MonkiProjectsAPI.decoder }
	public var dataLoader: DataLoader { DataLoader(decoder: decoder) }
	
	public let root: APIRoot
	public var auth: HTTPAuthentication?
	
	public init(root: APIRoot, auth: HTTPAuthentication? = nil) {
		self.root = root
		self.auth = auth
	}
	
	public func listUsers(page: PageRequest) -> Publisher<Page<User.Public.Small>> {
		return self.authenticatedRequest(endpoints.listUsers(page: page))
	}
	
}

extension MPUsersAPI {
	
	internal struct Endpoints: APIEndpoints {
		
		let root: APIRoot
		
		func listUsers(page: PageRequest) -> Endpoint {
			return self.get(
				"abc",
				queryItems: page.queryItems
			)
		}
		
	}
	
}
