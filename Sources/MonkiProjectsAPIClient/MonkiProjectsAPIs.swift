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
	
	// MARK: - Nested types
	
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
	
	// MARK: - Properties
	
	/// A session, where custom server is set and credentials are stored
	public var session: WebAPISession
	
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
	
	/// Monki Projects' Users API
	public var usersAPI: WebUserRepository
	
	/// Monki Projects' Auth API
	public var authAPI: WebAuthRepository
	
	/// Monki Projects' Places API
	public var placesAPI: WebPlacesRepository
	
	// MARK: - Lifecycle
	
	public init(
		server: Server = .production,
		urlSession: URLSession = .shared,
		auth: HTTPAuthentication? = nil
	) {
		self.session = WebAPISession(server: server.wrappedValue, urlSession: urlSession, auth: auth)
		self.usersAPI = MPAPIUserRepository(session: self.session)
		self.authAPI = MPAPIAuthRepository(session: self.session)
		self.placesAPI = MPAPIPlaceRepository(session: self.session)
	}
	
	// TODO: Cancel ongoing requests in APIs?
	
}
