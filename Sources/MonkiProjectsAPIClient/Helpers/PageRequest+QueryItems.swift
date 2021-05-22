//
//  PageRequest+QueryItems.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import MonkiProjectsModel

extension PageRequest: QueryParam {
	
	public var queryItems: [URLQueryItem] {
		return [
			.init(name: "page", value: self.page.description),
			.init(name: "per", value: self.per.description),
		]
	}
	
}
