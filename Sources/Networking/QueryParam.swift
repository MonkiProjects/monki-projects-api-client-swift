//
//  QueryParam.swift
//  Networking
//
//  Created by Rémi Bardon on 22/05/2021.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation

public protocol QueryParam {
	
	var queryItems: [URLQueryItem] { get }
	
}

extension Optional: QueryParam where Wrapped: QueryParam {
	
	public var queryItems: [URLQueryItem] {
		return self?.queryItems ?? []
	}
	
}
