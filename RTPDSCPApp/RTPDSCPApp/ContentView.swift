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
	@ObservedObject private var sdkManager = WorkspaceONEManager.shared
	
	var body: some View {
		VStack(spacing: 20) {
			Text("RTP DSCP Sender")
				.font(.title)

			// App version label
			Text(sdkManager.appVersion)
				.font(.subheadline)
				.foregroundColor(.gray)
			
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
			.buttonStyle(.plain)
			.foregroundColor(.blue)

			Divider()
				.padding(.vertical, 10)

			// Display SDK status
			Text(sdkManager.sdkStatus)
				.foregroundColor(.gray)
				.multilineTextAlignment(.center)
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
