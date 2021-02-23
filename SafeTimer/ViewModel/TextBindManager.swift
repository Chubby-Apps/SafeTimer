//
//  TextBindManager.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 13/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import Foundation
//MARK: - Código para limitar el texto
class TextBindingManager: ObservableObject {
    
    @Published var tituloTemporizador = "" {
        didSet {
            if tituloTemporizador.count > characterLimit && oldValue.count <= characterLimit {
                tituloTemporizador = oldValue
            }
        }
    }
    @Published var duracionHoraString = "" {
        didSet {
            let filtered = duracionHoraString.filter { "0123456789".contains($0) }
            if filtered != duracionHoraString {
                duracionHoraString = filtered
            }
            if duracionHoraString.count > duracionLimit && oldValue.count <= duracionLimit {
                duracionHoraString = oldValue
            }
            if duracionHoraString != "" {
                duracionHora = Int(duracionHoraString)! * 3600
            } else {
                duracionHora = 0
            }
        }
    }
    @Published var duracionMinutoString = "" {
        didSet {
            let filtered = duracionMinutoString.filter { "0123456789".contains($0) }
            if filtered != duracionMinutoString {
                duracionMinutoString = filtered
            }
            if duracionMinutoString.count > duracionLimit && oldValue.count <= duracionLimit {
                duracionMinutoString = oldValue
            }
            if duracionMinutoString != "" {
                duracionMinuto = Int(duracionMinutoString)! * 60
            } else {
                duracionMinuto = 0
            }
        }
    }
    
    @Published var duracionMinuto: Int = 0
    @Published var duracionHora: Int = 0
    
    var duracionTotal: Int {
        return duracionMinuto + duracionHora
    }
    
    private let duracionLimit = 2
    private let characterLimit = 25
    
}
