//
//  HostingController.swift
//  SafeTimerWatch Extension
//
//  Created by Asier G. Morato on 14/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<AnyView> {
    
    lazy var ajustes = ajustesModel()
    
    override var body: AnyView {
        return AnyView(ContentView().environmentObject(ajustesModel()))
    }
}
