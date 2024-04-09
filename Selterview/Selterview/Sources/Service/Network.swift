//
//  Network.swift
//  Selterview
//
//  Created by woo0 on 3/26/24.
//

import Foundation
import Network
import ComposableArchitecture

struct Network {
	var networkCheck: () -> Bool
}

extension Network: DependencyKey {
	static let liveValue = Network(
		networkCheck: {
			let queue = DispatchQueue.global()
			let monitor: NWPathMonitor = NWPathMonitor()
			var monitoringResult = false
			
			monitor.start(queue: queue)
			monitor.pathUpdateHandler = { path in
				monitoringResult = path.status == .satisfied
			}
			print(monitoringResult)
			monitor.cancel()
			return monitoringResult
		})
}

extension DependencyValues {
	var network: Network {
		get { self[Network.self] }
		set { self[Network.self] = newValue }
	}
}
