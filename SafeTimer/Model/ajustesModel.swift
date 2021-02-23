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
        static let notificacionRecordatorio = "notificacionRecordatorio"
        static let numeroDeUsos = "numeroDeUsos"
    }
    
    private let cancellable: Cancellable
    private let defaults: UserDefaults
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.notificacionRecordatorio: true,
            Keys.numeroDeUsos: false,
        ])
        
        cancellable = NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in () }
            .subscribe(objectWillChange)
    }
    
    //MARK: - Valores
    var notificacionRecordatorio: Bool {
        set { defaults.set(newValue, forKey: Keys.notificacionRecordatorio) }
        get { defaults.bool(forKey: Keys.notificacionRecordatorio) }
    }
    var numeroDeUsos: Bool {
        set { defaults.set(newValue, forKey: Keys.numeroDeUsos) }
        get { defaults.bool(forKey: Keys.numeroDeUsos) }
    }
}

