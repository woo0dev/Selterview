//
//  Network.swift
//  Selterview
//
//  Created by woo0 on 3/26/24.
//

import Foundation
import Network

final class Network {
	static let shared = Network()
	private let queue = DispatchQueue.global()
	private let monitor: NWPathMonitor
	
	private init() {
		monitor = NWPathMonitor()
	}
	
	public func networkChack() -> Bool {
		var monitoringResult = false
		monitor.start(queue: queue)
		monitor.pathUpdateHandler = { path in
			monitoringResult = path.status == .satisfied
		}
		monitor.cancel()
		return monitoringResult
	}
}
