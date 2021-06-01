//
//  MonkiProjectsAPIs.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 06/10/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import MonkiProjectsModel
import Networking

public final class MonkiProjectsAPIs: ObservableObject {
	
	public enum Server {
		
		case production, staging, local
		
		var wrappedValue: APIServer {
			switch self {
			case .production:
				return APIServer(scheme: "https", host: "api.monkiprojects.com")
			case .staging:
				return APIServer(scheme: "https", host: "staging.api.monkiprojects.com")
			case .local:
				// swiftlint:disable:next number_separator
				return APIServer(scheme: "http", host: "localhost", port: 8080)
			}
		}
		
	}
	
	internal static let encoder: JSONEncoder = {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .iso8601
		return encoder
	}()
	internal static let decoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		return decoder
	}()
	
	public var usersAPI: WebUserRepository
	public var authAPI: WebAuthRepository
	public var placemarksAPI: WebPlacemarksRepository
	
	public init(
		server: Server = .production,
		session: URLSession = .shared,
		auth: HTTPAuthentication? = nil,
		customUsersAPI: WebUserRepository? = nil,
		customAuthAPI: WebAuthRepository? = nil,
		customPlacemarksAPI: WebPlacemarksRepository? = nil
	) {
		func makeAPI<T>(_ initializer: (APIServer, URLSession, HTTPAuthentication?) -> T) -> T {
			initializer(server.wrappedValue, session, auth)
		}
		self.usersAPI = customUsersAPI ?? makeAPI(MPAPIUserRepository.init(server:session:auth:))
		self.authAPI = customAuthAPI ?? makeAPI(MPAPIAuthRepository.init(server:session:auth:))
		self.placemarksAPI = customPlacemarksAPI ?? makeAPI(MPAPIPlacemarkRepository.init(server:session:auth:))
	}
	
	public func forEachAPI(apply body: (API) throws -> Void) rethrows {
		try Mirror(reflecting: self).children
			.compactMap { $0 as? API }
			.forEach(body)
		self.objectWillChange.send()
	}
	
}
