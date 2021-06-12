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
	
	func listUsers(page: PageRequest?) -> AnyPublisher<Page<User.Public.Small>, Error>
	
	func createUser(_ create: User.Create) -> AnyPublisher<User.Private, Error>
	
	func getUser(_ userId: UUID) -> AnyPublisher<User.Public.Full, Error>
	
	func updateUser(_ userId: UUID, with update: User.Update) -> AnyPublisher<User.Public.Full, Error>
	
	func deleteUser(_ userId: UUID) -> AnyPublisher<Void, Error>
	
}

// MARK: - Functions with default parameters

extension WebUserRepository {
	
	public func listUsers() -> AnyPublisher<Page<User.Public.Small>, Error> {
		return self.listUsers(page: nil)
	}
	
}
