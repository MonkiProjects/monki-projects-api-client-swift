//
//  MPAuthAPITests.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

@testable import MonkiProjectsAPIClient
import XCTest
import MonkiProjectsModel

internal final class MPAuthAPITests: XCTestCase {
	
	func testFirstLogIn() throws {
		var api = MonkiProjectsAPI(server: .local, auth: nil)
		let create = User.Create.dummy()
		let user = try `await`(api.usersAPI.createUser(create))
		addTeardownBlock {
			_ = try? self.`await`(api.usersAPI.deleteUser(user.id))
		}
		let call = api
			.authAPI
			.logIn(username: create.username, password: create.password)
		let result = try `await`(call)
		api.auth = .bearer(token: result.value) // Update auth for teardown block
		
		XCTAssertEqual(result.value.count, 24)
	}
	
}
