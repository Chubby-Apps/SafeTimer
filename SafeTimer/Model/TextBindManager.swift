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
   @Published var duracionString = "" {
       didSet {
           let filtered = duracionString.filter { "0123456789".contains($0) }
           if filtered != duracionString {
               duracionString = filtered
           }
           if duracionString.count > duracionLimit && oldValue.count <= duracionLimit {
               duracionString = oldValue
           }
       }
   }
    private let duracionLimit = 2
    private let characterLimit = 20

}
