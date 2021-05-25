//
//  XCTestCase+TestAPI.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 25/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import MonkiProjectsAPIClient
import XCTest
import Networking

extension XCTestCase {
	
	internal func testApi(auth: HTTPAuthentication? = nil) -> MonkiProjectsAPI {
		return MonkiProjectsAPI(server: .local, auth: auth)
	}
	
}
