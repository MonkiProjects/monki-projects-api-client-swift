//
//  WebAuthRepository.swift
//  MonkiProjectsAPIClient
//
//  Created by Rémi Bardon on 01/06/2021.
//  Copyright © 2021 Monki Projects. All rights reserved.
//

import Foundation
import Combine
import Networking
import MonkiProjectsModel

public protocol WebAuthRepository: AnyObject, API {
	
	func logIn(username: String, password: String) -> AnyPublisher<User.Token.Private, Error>
	
	func getMe() -> AnyPublisher<User.Private, Error>
	
}
