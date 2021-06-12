//
//  SimpleInitializers.swift
//  MonkiProjectsAPIClientTests
//
//  Created by Rémi Bardon on 12/01/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import MonkiProjectsModel

extension User.Create {
	
	static func dummy(
		email: String = "\(UUID())@example.com",
		username: String = UUID().uuidString.prefix(32).lowercased(),
		displayName: String = UUID().uuidString.prefix(32).capitalized,
		password: String = "password",
		confirmPassword: String? = nil
	) -> Self {
		self.init(
			username: username,
			displayName: displayName,
			email: email,
			password: password,
			confirmPassword: confirmPassword ?? password
		)
	}
	
}

extension User.Update {
	
	static func dummy(
		username: String = UUID().uuidString.prefix(32).lowercased(),
		displayName: String = UUID().uuidString.prefix(32).capitalized
	) -> Self {
		self.init(
			username: username,
			displayName: displayName
		)
	}
	
}
