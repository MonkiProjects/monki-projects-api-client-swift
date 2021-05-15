//
//  PageRequest+QueryItems.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 15/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import MonkiProjectsModel

extension PageRequest {
	
	var queryItems: [URLQueryItem] {
		return [
			.init(name: "page", value: self.page.description),
			.init(name: "per", value: self.per.description),
		]
	}
	
}
