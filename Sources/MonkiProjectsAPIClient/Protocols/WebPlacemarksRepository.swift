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
	
	// MARK: - Combine Publishers
	
	func listPlacemarks(
		state: Placemark.State?,
		page: PageRequest?
	) -> AnyPublisher<Page<Placemark.Public>, Error>
	
	// MARK: - Swift async/await
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	func listPlacemarks(
		state: Placemark.State?,
		page: PageRequest?
	) async throws -> Page<Placemark.Public>
	
}

// MARK: - Functions with default parameters

extension WebPlacemarksRepository {
	
	public func listPlacemarks() -> AnyPublisher<Page<Placemark.Public>, Error> {
		return self.listPlacemarks(state: nil, page: nil)
	}
	
	@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
	public func listPlacemarks() async throws -> Page<Placemark.Public> {
		return try await self.listPlacemarks(state: nil, page: nil)
	}
	
}
