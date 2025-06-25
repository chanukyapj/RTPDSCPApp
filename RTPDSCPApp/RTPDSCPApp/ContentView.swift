//
//  ContentView.swift
//  RTPDSCPApp
//
//  Created by Admin1 on 20/06/25.
//

import SwiftUI
import AWSDK

struct ShareSheet: UIViewControllerRepresentable {
	var activityItems: [Any]

	func makeUIViewController(context: Context) -> UIActivityViewController {
		UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
	}

	func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ContentView: View {
	@State private var isSharing = false
	@State private var statusMessage: String = ""
	//    @StateObject private var viewModel = MyViewModel()
	
	
	var body: some View {
		
		//        viewModel.initAWSDK()
		
		VStack(spacing: 20) {
			Text("RTP DSCP Sender")
				.font(.title)
			
			Button("Send RTP Packet") {
				if let error = RTPDSCPSender.sendFakeRTPPacket(toHost: "2.207.189.132", port: 2060) {
					statusMessage = "Error: \(error)"
					FileLogger.shared.log("Error sending RTP packet: \(error)")
				} else {
					statusMessage = "✅ RTP Packet sent successfully!"
					FileLogger.shared.log("RTP Packet sent successfully!")
				}
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(10)
			
			Text(statusMessage)
				.foregroundColor(statusMessage.contains("Error") ? .red : .green)
				.padding()
			
			Button("Share Log File") {
							isSharing = true
						}
						.buttonStyle(.plain) // Removes default button styling
						.foregroundColor(.blue) // Optional: Make it look tappable (like a link)
		}
		.padding()
		.sheet(isPresented: $isSharing) {
			if let logURL = FileLogger.shared.getLogFileURL() as URL? {
						ShareSheet(activityItems: [logURL])
					} else {
						Text("Log file not found.")
					}
				}
	}
}

#Preview {
	ContentView()
}
