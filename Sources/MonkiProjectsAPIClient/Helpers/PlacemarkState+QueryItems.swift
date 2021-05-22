//
//  PlacemarkState+QueryItems.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 22/05/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Networking
import MonkiMapModel

extension Placemark.State: QueryParam {
	
	public var queryItems: [URLQueryItem] {
		return [.init(name: "state", value: self.rawValue)]
	}
	
}
