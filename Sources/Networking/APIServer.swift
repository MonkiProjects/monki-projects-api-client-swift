//
//  APIServer.swift
//  Networking
//
//  Created by Rémi Bardon on 03/09/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation

public struct APIServer {
	
	public let scheme, host: StaticString
	
	public init(scheme: StaticString, host: StaticString) {
		self.scheme = scheme
		self.host = host
	}
	
}
