//
//  MonkiProjectsAPI.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 06/10/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import MonkiProjectsModel
import Networking

public struct MonkiProjectsAPI {
	
	public enum Server {
		
		case production, staging, local
		
		var wrappedValue: APIServer {
			switch self {
			case .production:
				return APIServer(scheme: "https", host: "api.monkiprojects.com")
			case .staging:
				return APIServer(scheme: "https", host: "staging.api.monkiprojects.com")
			case .local:
				return APIServer(scheme: "https", host: "localhost")
			}
		}
		
	}
	
	internal static let encoder = JSONEncoder()
	internal static let decoder = JSONDecoder()
	
	public let server: Server
	
	public var auth: HTTPAuthentication?
	
	public var authAPI: MPAuthAPI { makeAPI(MPAuthAPI.init(server:auth:)) }
	
	public var placemarksAPI: MPPlacemarksAPI { makeAPI(MPPlacemarksAPI.init(server:auth:)) }
	
	public init(server: Server = .production, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.auth = auth
	}
	
	private func makeAPI<T>(_ initializer: (APIServer, HTTPAuthentication?) -> T) -> T {
		initializer(self.server.wrappedValue, self.auth)
	}
	
}
