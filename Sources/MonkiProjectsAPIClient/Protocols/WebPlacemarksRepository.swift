//
//  WebPlacemarksRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 01/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import Networking
import MonkiProjectsModel
import MonkiMapModel

public protocol WebPlacemarksRepository: AnyObject, WebAPI {
	
	func listPlacemarks(
		state: Placemark.State?,
		page: PageRequest?
	) -> AnyPublisher<Page<Placemark.Public>, Error>
	
}

// MARK: - Functions with default parameters

extension WebPlacemarksRepository {
	
	public func listPlacemarks() -> AnyPublisher<Page<Placemark.Public>, Error> {
		return self.listPlacemarks(state: nil, page: nil)
	}
	
}
