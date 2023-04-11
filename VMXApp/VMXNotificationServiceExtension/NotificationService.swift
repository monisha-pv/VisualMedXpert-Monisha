//
//  NotificationService.swift
//  VMXNotificationServiceExtension
//
//  Created by Monisha Vadivelu on 11/04/2023.
//


import UserNotifications
import UIKit

class NotificationService: UNNotificationServiceExtension {
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else {
            return
        }
        
        // Modify the notification content here as needed
        let customContent = createCustomNotificationContent()
        bestAttemptContent.title = customContent.title
        bestAttemptContent.subtitle = customContent.subtitle
        bestAttemptContent.body = customContent.body
        
        // Load the image attachment
        guard let urlString = bestAttemptContent.userInfo["image_url"] as? String, let fileUrl = URL(string: urlString) else {
            return
        }
        URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
            if let location = location {
                let attachmentIdentifier = UUID().uuidString
                do {
                    let attachment = try UNNotificationAttachment(identifier: attachmentIdentifier, url: location, options: nil)
                    bestAttemptContent.attachments = [attachment]
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            // Serve the notification content
            self.contentHandler?(bestAttemptContent)
        }.resume()
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    // Define your custom notification content here
    private func createCustomNotificationContent() -> (title: String, subtitle: String, body: String) {
        let title = "Custom notification title"
        let subtitle = "Custom notification subtitle"
        let body = "Custom notification body"
        return (title, subtitle, body)
    }
}


