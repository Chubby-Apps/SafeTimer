//
//  Constants.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 05/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import Foundation

struct Keys {
    static let notificacionID = "mascarillas"
    static let categoriaNotificacion = "alertaMascarilla"
    static let pararTemporizadorAccion = "pTemporizadorA"
    static let cerrarTemporizadorAccion = "cTemporizadorA"
    static let nuevaMascarillaAccion = "nMascarillaA"
    static let quirurgica = "quirurgica"
    static let FFP2 = "FFP2"
    static let FFP3 = "FFP3"
    static let otro = "otro"
    static let notificacionRecordatorio = "notificacionRecordatorio"
    static let numeroDeUsos = "numeroDeUsos"
}

extension UserDefaults {
  enum Key: String {
    case reviewWorthyActionCount
    case lastReviewRequestAppVersion
  }

  func integer(forKey key: Key) -> Int {
    return integer(forKey: key.rawValue)
  }

  func string(forKey key: Key) -> String? {
    return string(forKey: key.rawValue)
  }

  func set(_ integer: Int, forKey key: Key) {
    set(integer, forKey: key.rawValue)
  }

  func set(_ object: Any?, forKey key: Key) {
    set(object, forKey: key.rawValue)
  }
}
