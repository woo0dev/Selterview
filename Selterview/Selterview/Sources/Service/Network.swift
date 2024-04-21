//
//  Network.swift
//  Selterview
//
//  Created by woo0 on 3/26/24.
//

import Foundation
import Network

final class NetworkCheck {
	static let shared = NetworkCheck()
	private let queue = DispatchQueue.global()
	private let monitor: NWPathMonitor = NWPathMonitor()
	public private(set) var isConnected: Bool = false
	
	public func startMonitoring() {
		monitor.start(queue: queue)
		monitor.pathUpdateHandler = { [weak self] path in
			self?.isConnected = path.status == .satisfied
			if self?.isConnected == true {
				print("네트워크연결됨")
			} else {
				print("네트워크 연결 오류")
			}
		}
	}
	
	public func stopMonitoring() {
		monitor.cancel()
	}
}
