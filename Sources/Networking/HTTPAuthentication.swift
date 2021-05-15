//
//  HTTPAuthentication.swift
//  Networking
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation

public enum HTTPAuthentication {
	case basic(username: String, password: String)
	case bearer(token: String)
}

extension URLRequest {
	
	public mutating func applyAuth(_ auth: HTTPAuthentication?) {
		switch auth {
		case let .basic(username, password):
			self.setBasicAuth(username: username, password: password)
		case let .bearer(token):
			self.setBearerAuth(token: token)
		case .none:
			break
		}
	}
	
}
