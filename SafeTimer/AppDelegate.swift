//
//  AppDelegate.swift
//  Mascarillas
//
//  Created by Asier G. Morato on 04/05/2020.
//  Copyright © 2020 Asier G. Morato. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Notificaciones
        UNUserNotificationCenter.current().delegate = self
        let pararTemporizadorAccion = UNNotificationAction(identifier: Keys.pararTemporizadorAccion, title: "Cerrar", options: [.destructive])
        let nuevaMascarillaAccion = UNNotificationAction(identifier: Keys.nuevaMascarillaAccion, title: "Iniciar nuevo temporizador", options: [.foreground])
        let category = UNNotificationCategory(identifier: Keys.categoriaNotificacion, actions: [nuevaMascarillaAccion, pararTemporizadorAccion], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    //MARK: - Notificaciones
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == Keys.nuevaMascarillaAccion {
            NotificationCenter.default.post(name: NSNotification.Name("nuevaMascarilla"), object: nil)
            
        } else if response.actionIdentifier == Keys.pararTemporizadorAccion {
            
        }
        
        completionHandler()
        
    }
    
    //MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Mascarillas")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

