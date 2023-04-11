//
//  VisualMedXpertApp.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI
import FirebaseCore
import UIKit
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
      // Request user's permission for notifications
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
          if granted {
              print("Notifications permission granted")
          } else if let error = error {
              print("Error requesting notification permission: \(error.localizedDescription)")
          }
      }
      
      // Register for remote notifications
      application.registerForRemoteNotifications()

    return true
  }
}

@main
struct VisualMedXpertApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RegistrationView()
            
        }
    }
}

