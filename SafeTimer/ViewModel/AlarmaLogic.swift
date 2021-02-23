//
//  AlarmaLogic.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 05/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import Foundation
import UserNotifications

struct AlarmaLogic {
	
	private let repetir = UserDefaults.standard.bool(forKey: Keys.notificacionRecordatorio)
	
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
            content.title = NSString.localizedUserNotificationString(forKey: "timeToChange", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "enoughUse", arguments: nil)
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS, repeats: false)
            
            let request = UNNotificationRequest(identifier: ID.uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
		let addRequest5 = {
			let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "timeToChange", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "enoughUse", arguments: nil)
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS+300, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(ID.uuidString)5", content: content, trigger: trigger)
            center.add(request)
		}
		let addRequest10 = {
			let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "timeToChange", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "enoughUse", arguments: nil)
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS+600, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(ID.uuidString)10", content: content, trigger: trigger)
            center.add(request)
		}
		
		let addRequest30 = {
			let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "timeToChange", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "enoughUse", arguments: nil)
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS+1800, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(ID.uuidString)30", content: content, trigger: trigger)
            center.add(request)
		}
		
		let addRequest60 = {
			let content = UNMutableNotificationContent()
            content.title = NSString.localizedUserNotificationString(forKey: "timeToChange", arguments: nil)
            content.body = NSString.localizedUserNotificationString(forKey: "enoughUse", arguments: nil)
            content.categoryIdentifier = Keys.categoriaNotificacion
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duracionS+3600, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(ID.uuidString)60", content: content, trigger: trigger)
            center.add(request)
		}
		
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
				
				if self.repetir {
					addRequest5()
					addRequest10()
					addRequest30()
					addRequest60()
				}
				
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
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [ID.uuidString, "\(ID.uuidString)5", "\(ID.uuidString)10", "\(ID.uuidString)30", "\(ID.uuidString)60"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [ID.uuidString, "\(ID.uuidString)5", "\(ID.uuidString)10", "\(ID.uuidString)30", "\(ID.uuidString)60"])
        print("Temporizador parado")
    }
}
