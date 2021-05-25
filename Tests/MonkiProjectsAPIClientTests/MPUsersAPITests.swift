//
//  MPUsersAPITests.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

@testable import MonkiProjectsAPIClient
import XCTest
import MonkiProjectsModel

internal final class MPUsersAPITests: XCTestCase {
	
	// MARK: - Valid Domain
	
	func testCreateUser() throws {
		let create = User.Create.dummy()
		let request = self.testApi().usersAPI.createUser(create)
		let user = try self.`await`(request)
		self.deletePossiblyCreatedUserAfterTestFinishes(user.id, create.username, create.password)
		
		XCTAssertEqual(user.username, create.username)
	}
	
	func testListUsers() throws {
		let request = self.testApi().usersAPI.listUsers()
		let users = try self.`await`(request)
		
		XCTAssertEqual(users.metadata.page, 1)
	}
	
	// MARK: - Invalid Domain
	
}
