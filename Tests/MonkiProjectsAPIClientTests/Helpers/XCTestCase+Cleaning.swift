//
//  XCTestCase+Cleaning.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import MonkiProjectsAPIClient
import XCTest
import Networking

extension XCTestCase {
	
	/// Delete created user
	internal func deletePossiblyCreatedUserAfterTestFinishes(
		_ userId: UUID,
		_ username: String,
		_ password: String
	) {
		addTeardownBlock {
			do {
				let logIn = self.testApi().authAPI.logIn(username: username, password: password)
				if let token = try? self.`await`(logIn).value {
					let delete = self.testApi(auth: .bearer(token: token)).usersAPI.deleteUser(userId)
					_ = try self.`await`(delete)
				}
			} catch {
				XCTFail(error.localizedDescription)
			}
		}
	}
	
}
