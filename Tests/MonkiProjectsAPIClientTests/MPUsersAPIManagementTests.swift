//
//  MPUsersAPIManagementTests.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

@testable import MonkiProjectsAPIClient
import XCTest
import MonkiProjectsModel
import Networking

internal final class MPUsersAPIManagementTests: UserTestCase {
	
	// MARK: - Valid Domain
	
	func testUpdateUser() throws {
		let user = try XCTUnwrap(self.user)
		let token = try XCTUnwrap(self.token)
		let usersAPI = self.testApi(auth: .bearer(token: token)).usersAPI
		
		let update = User.Update.dummy()
		let request = usersAPI.updateUser(user.id, with: update)
		let res = try self.`await`(request)
		
		XCTAssertEqual(res.username, update.username)
		XCTAssertEqual(res.displayName, update.displayName)
	}
	
	// MARK: - Invalid Domain
	
	func testUpdateUserWithoutAuthorisation() throws {
		let user = try XCTUnwrap(self.user)
		
		let update = User.Update.dummy()
		let request = self.testApi().usersAPI.updateUser(user.id, with: update)
		
		do {
			_ = try self.`await`(request)
			XCTFail("Update successful with no credentials")
		} catch {
			if case let .httpError(code: 401, message) = error as? NetworkError {
				XCTAssertEqual(message, "{\"error\":true,\"reason\":\"Invalid authorization token.\"}")
			} else {
				XCTFail("Incorrect error: \(error)")
			}
		}
	}
	
}
