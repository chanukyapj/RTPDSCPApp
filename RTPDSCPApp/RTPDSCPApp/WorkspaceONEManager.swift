//
//  WorkspaceONEManager.swift
//  RTPDSCPApp
//
//  Created by Admin1 on 26/06/25.
//


import Foundation
import AWSDK

class WorkspaceONEManager: NSObject, AWControllerDelegate, ObservableObject {
	static let shared = WorkspaceONEManager()
	
	@Published var sdkStatus: String = "SDK not initialized"
	private var sdkStarted = false
	
	// Fetch app version and build number
	var appVersion: String {
		let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
		let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
		return "Version \(version) (\(build))"
	}
	
	func startSDK() {
		guard !sdkStarted else { return }
		sdkStarted = true
		
		let controller = AWController.clientInstance()
		controller.callbackScheme = "airwatchCallbackSchemeTest" // Replace with your actual scheme
		controller.teamID = bundleSeedID() ?? ""
		controller.delegate = self
		controller.start()
		
		FileLogger.shared.log("App Version : \(appVersion)")
	}
	
	func handleOpenURL(_ url: URL, fromApplication: String?) -> Bool {
		return AWController.clientInstance().handleOpenURL(url, fromApplication: fromApplication)
	}
	
	func controllerDidFinishInitialCheck(error: NSError?) {
		if let err = error {
			sdkStatus = "SDK init failed: \(err.localizedDescription)"
			FileLogger.shared.log("SDK init failed: \(err)")
		} else {
			sdkStatus = "SDK initialized successfully ✅"
			FileLogger.shared.log("SDK initialized successfully.")
		}
	}
	
	func bundleSeedID() -> String? {
		let tempAccountName = "bundleSeedID"
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: tempAccountName,
			kSecAttrService as String: "",
			kSecReturnAttributes as String: true
		]
		
		var result: CFTypeRef?
		var status = SecItemCopyMatching(query as CFDictionary, &result)
		
		if status == errSecItemNotFound {
			status = SecItemAdd(query as CFDictionary, &result)
		}
		
		if status != errSecSuccess {
			return nil
		}
		
		guard
			let dict = result as? [String: Any],
			let accessGroup = dict[kSecAttrAccessGroup as String] as? String,
			let bundleSeedID = accessGroup.components(separatedBy: ".").first
		else {
			return nil
		}
		
		return bundleSeedID
	}
}
