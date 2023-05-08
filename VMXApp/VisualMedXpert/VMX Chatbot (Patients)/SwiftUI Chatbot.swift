//
//  SwiftUI Chatbot.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 01/04/2023.
//

import SwiftUI


struct SwiftUI_Chatbot: View {
    @State private var messageText = ""
    @State var messages: [String] = ["Welcome to VMX ChatBot"]
    
    
    var body: some View {
        VStack {
            HStack {
                Text("VMXBot")
                    .font(.largeTitle)
                    .bold()
                
                Image(systemName: "text.bubble.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color.black)
            }
            
            ScrollView {
                ForEach(messages, id: \.self) { message in
                    if message.contains("[USER]") {
                        let newMessage = message.replacingOccurrences(of:
                        "[USER]", with: "")
                        
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.black.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        HStack {
                            Text(message)
                                .padding()
                                .background(.gray.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.10))
            
            HStack {
                TextField("Type something", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        // send message
                        sendMessage(message: messageText)
                    }
                
                Button {
                    // user sends a message
                    sendMessage(message: messageText)
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
        }
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getVMXBotRes(message: message))
            }
        }
    }
}

struct SwiftUI_Chatbot_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI_Chatbot()
    }
}
