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
		// Delete created user
		addTeardownBlock {
			do {
				let logIn = self.testApi().authAPI.logIn(username: create.username, password: create.password)
				if let token = try? self.`await`(logIn).value {
					let delete = self.testApi(auth: .bearer(token: token)).usersAPI.deleteUser(user.id)
					_ = try self.`await`(delete)
				}
			} catch {
				XCTFail(error.localizedDescription)
			}
		}
		
		XCTAssertEqual(user.username, create.username)
	}
	
	func testListUsers() throws {
		let request = self.testApi().usersAPI.listUsers()
		let users = try self.`await`(request)
		
		XCTAssertEqual(users.metadata.page, 1)
	}
	
	// MARK: - Invalid Domain
	
}
