//
//  WebAuthRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 01/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import Networking
import MonkiProjectsModel

public protocol WebAuthRepository: AnyObject, WebAPI {
	
	// MARK: - Combine Publishers
	
	func logIn(username: String, password: String) -> AnyPublisher<User.Token.Private, Error>
	
	func getMe() -> AnyPublisher<User.Private, Error>
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func logIn(username: String, password: String) async throws -> User.Token.Private
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func getMe() async throws -> User.Private
	
}
