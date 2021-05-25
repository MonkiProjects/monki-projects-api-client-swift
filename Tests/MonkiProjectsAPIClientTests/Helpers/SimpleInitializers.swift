//
//  SimpleInitializers.swift
//  MonkiProjectsAPITests
//
//  Created by Rémi Bardon on 12/01/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import MonkiProjectsModel

extension User.Create {
	
	static func dummy(
		email: String = "\(UUID())@example.com",
		username: String = UUID().uuidString,
		displayName: String = UUID().uuidString,
		password: String = "password",
		confirmPassword: String? = nil
	) -> Self {
		self.init(
			email: email,
			username: username,
			displayName: displayName,
			password: password,
			confirmPassword: confirmPassword ?? password
		)
	}
	
}
