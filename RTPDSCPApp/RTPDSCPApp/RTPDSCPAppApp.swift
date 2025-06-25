//
//  RTPDSCPAppApp.swift
//  RTPDSCPApp
//
//  Created by Admin1 on 20/06/25.
//

import SwiftUI
import AWSDK


@main
struct RTPDSCPAppApp: App {
    @StateObject private var viewModel = MyViewModel()
    @State var showingAlert = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class MyViewModel: AWControllerDelegate, ObservableObject {
    init() {
        initialisedAWSDK()
    }
    
    func initialisedAWSDK () {
        let awcontroller = AWController.clientInstance()
        awcontroller.callbackScheme = "airwatchCallbackSchemeTest"
        awcontroller.delegate = self
        awcontroller.start()
    }
    
    func controllerDidFinishInitialCheck(error: NSError?) {        
        if (error != nil) {
            print("AWSDK initialised failed:")
            print("Domain: \(error!.domain)")
            print("Code: \(error!.code)")
            print("Description: \(error!.localizedDescription)")
        }else {
            print("AWSDK initialised success")
        }
    }
}


