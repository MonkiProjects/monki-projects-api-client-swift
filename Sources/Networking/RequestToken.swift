//
//  RequestToken.swift
//  Networking
//
//  Created by Rémi Bardon on 03/09/2020.
//  Copyright © 2020 Monki Projects. All rights reserved.
//

import Foundation
import Combine

// swiftlint:disable file_types_order

/// Inspired by [Using tokens to handle async Swift code](https://www.swiftbysundell.com/articles/using-tokens-to-handle-async-swift-code/#a-token-for-every-request)
public protocol RequestToken {
	
	func cancel()
	
}

public final class ZipToken: RequestToken {
	
	private var tokens: [RequestToken]
	
	internal init(tokens: [RequestToken]) {
		self.tokens = tokens
	}
	
	public func cancel() {
		for token in tokens {
			token.cancel()
		}
	}
	
}

public final class URLSessionDataTaskToken: RequestToken {
	
	private var task: URLSessionDataTask?
	
	internal init(task: URLSessionDataTask) {
		self.task = task
	}
	
	public func cancel() {
		task?.cancel()
	}
	
}

public final class CombineCancellableToken: RequestToken {
	
	private var cancellable: AnyCancellable?
	
	internal init(cancellable: AnyCancellable) {
		self.cancellable = cancellable
	}
	
	public func cancel() {
		cancellable?.cancel()
	}
	
}

// swiftlint:enable file_types_order
