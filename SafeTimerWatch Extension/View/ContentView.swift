//
//  ContentView.swift
//  SafeTimerWatch Extension
//
//  Created by Asier G. Morato on 14/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import Combine
import CoreData
import CloudKit

struct ContentView: View {
    var managedObjectContext = (WKExtension.shared().delegate as! ExtensionDelegate).persistentContainer.viewContext
    var body: some View {
        ListaTemporizadores().environment(\.managedObjectContext, managedObjectContext)
    }
}

//MARK: - Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
    }
}
#endif
