import SwiftUI

@main
struct RTPDSCPApp: App {
	@Environment(\.scenePhase) private var scenePhase

	var body: some Scene {
		WindowGroup {
			ContentView()
				.onOpenURL { url in
					_ = WorkspaceONEManager.shared.handleOpenURL(url, fromApplication: nil)
				}
		}
		.onChange(of: scenePhase) {
			if scenePhase == .active {
				WorkspaceONEManager.shared.startSDK()
			}
		}
	}
}
