//
//  FileLogger.swift
//  RTPDSCPApp
//
//  Created by Admin1 on 25/06/25.
//


import Foundation

@objc class FileLogger: NSObject {

	// Singleton instance accessible from Objective-C
	@objc static let shared = FileLogger()

	private let logQueue = DispatchQueue(label: "com.example.FileLoggerQueue")
	private var logFileURL: URL

	private override init() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		logFileURL = documentsDirectory.appendingPathComponent("app_log.txt")
	}

	// Objective-C compatible logging method
	@objc func log(_ message: String) {
		logQueue.async {
			let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
			let logMessage = "[\(timestamp)] \(message)\n"

			if let data = logMessage.data(using: .utf8) {
				if FileManager.default.fileExists(atPath: self.logFileURL.path) {
					if let fileHandle = try? FileHandle(forWritingTo: self.logFileURL) {
						fileHandle.seekToEndOfFile()
						fileHandle.write(data)
						fileHandle.closeFile()
					}
				} else {
					try? data.write(to: self.logFileURL)
				}
			}
		}
	}

	// Method to get log file path (can be useful in Objective-C)
	@objc func getLogFilePath() -> String {
		return logFileURL.path
	}
	
	// Method to get log file url
	@objc func getLogFileURL() -> URL {
		return logFileURL
	}
}
