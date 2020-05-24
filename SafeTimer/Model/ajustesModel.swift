//
//  ajustesModel.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 06/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import Combine
import SwiftUI

final class ajustesModel: ObservableObject {
    private enum Keys {
        static let quirurgica = "quirurgica"
        static let FFP2 = "FFP2"
        static let FFP3 = "FFP3"
        static let otro = "otro"
    }
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.quirurgica: 4,
            Keys.FFP2: 8,
            Keys.FFP3: 8,
            Keys.otro: 4,
        ])
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    //MARK: - Valores
    var quirurgica: Int {
        set { defaults.set(newValue, forKey: Keys.quirurgica) }
        get { defaults.integer(forKey: Keys.quirurgica) }
    }
    var ffp2: Int {
        set { defaults.set(newValue, forKey: Keys.FFP2) }
        get { defaults.integer(forKey: Keys.FFP2) }
    }
    var ffp3: Int {
        set { defaults.set(newValue, forKey: Keys.FFP3) }
        get { defaults.integer(forKey: Keys.FFP3) }
    }
    var otro: Int {
        set { defaults.set(newValue, forKey: Keys.otro) }
        get { defaults.integer(forKey: Keys.otro) }
    }
}

