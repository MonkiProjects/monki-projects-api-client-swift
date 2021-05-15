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
	
	public enum Root {
		
		case production, staging, local
		
		var wrappedValue: APIRoot {
			switch self {
			case .production:
				return APIRoot(scheme: "https", host: "api.monkiprojects.com")
			case .staging:
				return APIRoot(scheme: "https", host: "staging.api.monkiprojects.com")
			case .local:
				return APIRoot(scheme: "https", host: "localhost")
			}
		}
		
	}
	
	internal static let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
	
	public let root: Root
	
	public var auth: HTTPAuthentication?
	
	public var authAPI: MPAuthAPI { makeAPI(MPAuthAPI.init(root:auth:)) }
	
	public var placemarksAPI: MPPlacemarksAPI { makeAPI(MPPlacemarksAPI.init(root:auth:)) }
	
	public init(root: Root = .production, auth: HTTPAuthentication? = nil) {
		self.root = root
		self.auth = auth
	}
	
	private func makeAPI<T>(_ initializer: (APIRoot, HTTPAuthentication?) -> T) -> T {
		initializer(self.root.wrappedValue, self.auth)
	}
	
}
