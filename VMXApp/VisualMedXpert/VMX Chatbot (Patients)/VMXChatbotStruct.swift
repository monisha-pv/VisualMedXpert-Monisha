//
//  VMXChatbotStruct.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 01/04/2023.
//

import Foundation

func getVMXBotRes(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there!"
    } else if tempMessage.contains("Bye") {
        return "Talk to you later!"
    } else if tempMessage.contains("how are you") {
        return "I'm fine, how about you"
    } else if tempMessage.contains("Thank you") {
        return "No problem!"
    } else if tempMessage.contains("advice") {
        return "Go ahead!"
    } else if tempMessage.contains("scan") && tempMessage.contains("results") {
        return "You should recieve them in the next 2-3 working days via text."
    } else if tempMessage.contains("book") && tempMessage.contains("appointment") {
        return "You can schedule an appointment using our online booking system on your portal"
    } else if tempMessage.contains("reschedule") {
        return "To reschedule your scan appointment, please log into your patient portal and select the 'Amend' option."
    } else if tempMessage.contains("update") {
        return "To reschedule your scan appointment, please log into your patient portal and select the 'Amend' option."
    } else if tempMessage.contains("change") {
        return "To reschedule your scan appointment, please log into your patient portal and select the 'Amend' option."
    } else if tempMessage.contains("cancel") {
        return "To cancel your scan appointment, please log into your patient portal and select the 'Cancel' option."
    } else if tempMessage.contains("location") {
        return "Choose the nearest scan centre/imaging facility."
    } else if tempMessage.contains("time") {
        return "Choose a time that suits you, your doctor will notify you with any changes."
    } else if tempMessage.contains("confirmation") {
        return "Allow your doctor to confirm your booking, please check your booking status."
    } else if tempMessage.contains("waiting for confirmation") {
        return "We apologize for any inconvenience caused by the wait time for your scan confirmation. We strive to provide the best possible experience for our patients."
    } else if tempMessage.contains("availability") {
            return "Scan appointments are subject to availability. Please check your patient portal for available dates and times. You doctor will notify you with confirmation"
    } else if tempMessage.contains("i have not recieved my scan results yet") {
        return "I'm sorry for this, please contact your scan centre"
    } else if tempMessage.contains("emergency") {
        return "If this is a medical emergency, please call your local emergency services immediately."
    } else if tempMessage.contains("delete") && tempMessage.contains("account") {
        return "your account will expire and be permanently deleted if not in use after 6 months"
    } else if tempMessage.contains("not") && tempMessage.contains("working") {
        return "We may be facing some technical issues, please retry in a few minutes."
    } else {
        return "I'm not sure I understand, please email admin@vmx.com, you will recieve a response to your email within 24 hours"
    }
}
