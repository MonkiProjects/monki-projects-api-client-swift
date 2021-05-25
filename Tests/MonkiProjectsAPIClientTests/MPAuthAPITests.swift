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
import Networking

internal final class MPAuthAPITests: XCTestCase {
	
	private var user: User.Private?
	private var token: String?
	private let password = "password"
	
	// MARK: - Setup
	
	override func setUp() {
		super.setUp()
		
		do {
			let api = self.api()
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
			let api = self.api(auth: .bearer(token: token))
			_ = try? self.`await`(api.usersAPI.deleteUser(user.id))
		} catch {
			XCTFail(error.localizedDescription)
		}
	}
	
	// MARK: - Valid Domain
	
	func testFirstLogIn() throws {
		let user = try XCTUnwrap(self.user)
		
		let request = self.api().authAPI.logIn(username: user.username, password: self.password)
		let token = try `await`(request)
		
		XCTAssertEqual(token.value.count, 24)
	}
	
	// MARK: - Invalid Domain
	
	// MARK: - Helpers
	
	private func api(auth: HTTPAuthentication? = nil) -> MonkiProjectsAPI {
		return MonkiProjectsAPI(server: .local, auth: auth)
	}
	
}
