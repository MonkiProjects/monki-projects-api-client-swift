//
//  URLRequest+Auth.swift
//  Networking
//
//  Created by Rémi Bardon on 04/08/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation

extension URLRequest {
	
	public mutating func setBasicAuth(username: String, password: String) {
		let loginString = "\(username):\(password)"
		
		guard let loginData = loginString.data(using: .utf8) else { return }
		let base64LoginString = loginData.base64EncodedString()
		
		self.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
	}
	
	public mutating func setBearerAuth(token: String) {
		self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
	}
	
}
