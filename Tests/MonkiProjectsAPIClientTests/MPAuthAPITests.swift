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

internal final class MPAuthAPITests: UserTestCase {
	
	// MARK: - Valid Domain
	
	func testLogInWithValidCredentials() throws {
		let user = try XCTUnwrap(self.user)
		
		let request = self.testApi().authAPI.logIn(username: user.username, password: self.password)
		let token = try self.`await`(request)
		
		XCTAssertEqual(token.value.count, 24)
	}
	
	func testGetMe() throws {
		let token = try XCTUnwrap(self.token)
		
		let expectedUser = try XCTUnwrap(self.user)
		
		let request = self.testApi(auth: .bearer(token: token)).authAPI.getMe()
		let user = try self.`await`(request)
		
		XCTAssertEqual(user.id, expectedUser.id)
	}
	
	// MARK: - Invalid Domain
	
	func testLogInWithInvalidCredentials() throws {
		let user = try XCTUnwrap(self.user)
		
		let request = self.testApi().authAPI.logIn(username: user.username, password: "invalid")
		do {
			_ = try self.`await`(request)
			XCTFail("Log in successful with invalid credentials")
		} catch {
			if case let .httpError(code: 401, message) = error as? NetworkError {
				XCTAssertEqual(message, "{\"error\":true,\"reason\":\"Invalid credentials for '\(user.username)'.\"}")
			} else {
				XCTFail("Incorrect error: \(error)")
			}
		}
	}
	
}
