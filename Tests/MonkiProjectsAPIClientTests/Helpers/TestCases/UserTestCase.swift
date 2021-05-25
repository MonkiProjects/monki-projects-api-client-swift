//
//  UserTestCase.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import MonkiProjectsAPIClient
import XCTest
import MonkiProjectsModel
import Networking

internal class UserTestCase: XCTestCase {
	
	// swiftlint:disable test_case_accessibility
	internal var user: User.Private?
	internal var token: String?
	internal let password = "password"
	// swiftlint:enable test_case_accessibility
	
	override func setUp() {
		super.setUp()
		
		do {
			let api = self.testApi()
			let create = User.Create.dummy(password: self.password)
			self.user = try `await`(api.usersAPI.createUser(create))
			let token = try `await`(api.authAPI.logIn(username: create.username, password: create.password))
			self.token = token.value
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
	override func tearDown() {
		super.tearDown()
		
		do {
			let user = try XCTUnwrap(self.user)
			let token = try XCTUnwrap(self.token)
			let api = self.testApi(auth: .bearer(token: token))
			_ = try? self.`await`(api.usersAPI.deleteUser(user.id))
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
}
