//
//  NetworkError.swift
//  Networking
//
//  Created by Rémi Bardon on 23/08/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation

public enum NetworkError: Error, CustomDebugStringConvertible, LocalizedError {
	
	case unableToComplete(error: Error)
	case invalidResponse
	case invalidData
	case encodingError(Error?)
	case httpError(code: Int, message: String? = nil)
	case decodingError(Error)
	case unauthorized
	case invalidURL
	
	public var debugDescription: String {
		switch self {
		case let .unableToComplete(error):
			return "Unable to complete the request: \(String(reflecting: error))"
		case .invalidResponse:
			return "Invalid response from servers"
		case .invalidData:
			return "Invalid data from servers"
		case let .encodingError(error):
			return "Encoding error: \(String(reflecting: error))"
		case let .httpError(code, message):
			return "Error \(code): \(message ?? "<no_message>")"
		case let .decodingError(error):
			return "Decoding error: \(String(reflecting: error))"
		case .unauthorized:
			return "Error setting authentication headers"
		case .invalidURL:
			return "Invalid URL endpoint"
		}
	}
	
	public var errorDescription: String? {
		switch self {
		case let .unableToComplete(error):
			return error.localizedDescription
		case .invalidResponse:
			return "Invalid response from the server. Please try again."
		case .invalidData:
			return "The data received from the server was invalid. Please try again."
		case .encodingError:
			return "We are unable to encode your data. Please try again."
		case let .httpError(code, message):
			switch code {
			case 404:
				return message ?? "Servers are probably down."
			default:
				return message ?? "Something bad happened."
			}
		case .decodingError:
			return "We had a problem decoding your data. Please try again."
		case .unauthorized:
			return """
			It looks like you're not connected, therefore we can't do what you asked for. \
			Please log out, log in, and try again.
			"""
		case .invalidURL:
			return "We had a problem finding the URL of one of our services. Please try again."
		}
	}
	
	public var failureReason: String? {
		#warning("Localize failure reasons")
		switch self {
		default:
			return nil
		}
	}
	
	public var recoverySuggestion: String? {
		#warning("Localize recovery suggestions")
		#warning("Describe localization")
		switch self {
		case .unableToComplete:
			return "Try connecting to a stable network (like Wi-Fi)."
		case .unauthorized:
			return "Try logging out and logging back in."
		default:
			return nil
		}
	}
	
}
