//
//  WebUserRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 01/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import Networking
import MonkiProjectsModel

public protocol WebUserRepository: AnyObject, WebAPI {
	
	// MARK: - Combine Publishers
	
	func listUsers(page: PageRequest?) -> AnyPublisher<Page<User.Public.Small>, Error>
	
	func createUser(_ create: User.Create) -> AnyPublisher<User.Private, Error>
	
	func getUser(_ userId: User.ID) -> AnyPublisher<User.Public.Full, Error>
	
	func updateUser(_ userId: User.ID, with update: User.Update) -> AnyPublisher<User.Public.Full, Error>
	
	func deleteUser(_ userId: User.ID) -> AnyPublisher<Void, Error>
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func listUsers(page: PageRequest?) async throws -> Page<User.Public.Small>
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func createUser(_ create: User.Create) async throws -> User.Private
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func getUser(_ userId: User.ID) async throws -> User.Public.Full
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func updateUser(_ userId: User.ID, with update: User.Update) async throws -> User.Public.Full
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func deleteUser(_ userId: User.ID) async throws
	
}

// MARK: - Functions with default parameters

extension WebUserRepository {
	
	public func listUsers() -> AnyPublisher<Page<User.Public.Small>, Error> {
		return self.listUsers(page: nil)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func listUsers() async throws -> Page<User.Public.Small> {
		return try await self.listUsers(page: nil)
	}
	
}
