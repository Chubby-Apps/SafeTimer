//
//  AlarmaLogic.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 05/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import SwiftUI
import UserNotifications

struct AlarmaLogic {
    func pedirPermisoNotificacion() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .alert]) { granted, error in
                if granted == true && error == nil {
                    print("Permiso para enviar notificaciones concedido")
                }
        }
    }
    
    
    func nuevaAlarma(duracionS: Double, ID: UUID) {
        let center = UNUserNotificationCenter.current()
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Es hora de cambiar"
            content.body = "Ya lo has usado el tiempo suficiente"
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS, repeats: false)
            
            let request = UNNotificationRequest(identifier: ID.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
                print("Temporizador creado")
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Permiso para enviar notificaciones concedido")
                        addRequest()
                        print("Temporizador creado")
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func pararAlarma(ID: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ID.uuidString])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [ID.uuidString])
        print("Temporizador parado")
    }
}
