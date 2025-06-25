//
//  ContentView.swift
//  RTPDSCPApp
//
//  Created by Admin1 on 20/06/25.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
	@State private var statusMessage: String = ""

	var body: some View {
		VStack(spacing: 20) {
			Text("RTP DSCP Sender")
				.font(.title)

			Button("Send RTP Packet") {
				if let error = RTPDSCPSender.sendFakeRTPPacket(toHost: "2.207.189.132", port: 2060) {
					statusMessage = "Error: \(error)"
				} else {
					statusMessage = "✅ RTP Packet sent successfully!"
				}
			}
			.padding()
			.background(Color.blue)
			.foregroundColor(.white)
			.cornerRadius(10)

			Text(statusMessage)
				.foregroundColor(statusMessage.contains("Error") ? .red : .green)
				.padding()
		}
		.padding()
	}
}

#Preview {
    ContentView()
}
