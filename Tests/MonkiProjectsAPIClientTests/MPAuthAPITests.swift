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

internal final class MPAuthAPITests: UserTestCase {
	
	// MARK: - Valid Domain
	
	func testFirstLogIn() throws {
		let user = try XCTUnwrap(self.user)
		
		let request = self.testApi().authAPI.logIn(username: user.username, password: self.password)
		let token = try `await`(request)
		
		XCTAssertEqual(token.value.count, 24)
	}
	
	// MARK: - Invalid Domain
	
}
