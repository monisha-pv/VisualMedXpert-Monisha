//
//  VMXBotStruct.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 03/02/2023.
//

import Foundation

func getVMXBotRes(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there!"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later!"
    } else if tempMessage.contains("how are you") {
        return "I'm fine, how about you"
    } else if tempMessage.contains("i would like some advice") {
        return "Go ahead!"
    } else if tempMessage.contains("when would i recieve my results for my blood test?") {
        return "You should recieve them in the next 2-3 working days via text."
    } else if tempMessage.contains("i have not recieved my results yet") {
        return "I'm sorry for this, please contact your GP surgery for more information."
    } else {
        return "I'm not sure I understand, please email admin@vmx.com"
    }
}

