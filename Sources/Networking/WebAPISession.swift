//
//  WebAPISession.swift
//  Networking
//
//  Created by Rémi Bardon on 12/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation

public final class WebAPISession {

	public var server: APIServer
	public var urlSession: URLSession
	public var auth: HTTPAuthentication?
	
	public init(server: APIServer, urlSession: URLSession, auth: HTTPAuthentication? = nil) {
		self.server = server
		self.urlSession = urlSession
		self.auth = auth
	}
	
}
