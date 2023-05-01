//
//  ScheduleScanUpdateView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/02/2023.
//

import SwiftUI

struct ScheduleScanUpdateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var scan: Scan
    
    var name: String = ""
    var email: String = ""
    var gender: String = ""
    var condition: String = ""
    var scanType: String = ""
    var centre: String = ""
    var date: String = ""
    var time: String = ""
    @State private var selectedTime = Date()
    
    
    var genders = ["Male", "Female", "Prefer not to say"]
    var scantypes = ["X-ray", "CT Scan", "MRI Scan", "Electrocardiogram (ECG)", "PET scan", "Angiography", "Ultrasound scan", "Echocardiogram"]
    var centres = ["Derriford Hospital", "Nuffield Health Plymouth Hospital"]
    
    
    var body: some View {
        NavigationView {
            List{
                Section{
                    TextField("Full name", text: $scan.name)
                    TextField("Email", text: $scan.email)
                    Picker("Gender", selection: $scan.gender) {
                        Text("").tag("") // Add empty tag to avoid selection issues
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Condition", text: $scan.condition)
                    Picker("Type of Scan", selection: $scan.scanType) {
                        Text("").tag("")
                        ForEach(scantypes, id: \.self) {
                            Text($0)
                        }
                        
                    }
                    Picker("Centre", selection: $scan.centre) {
                        Text("").tag("")
                        ForEach(centres, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Date", text: $scan.date)
                    DatePicker("Time", selection: $selectedTime, displayedComponents: [.hourAndMinute])
                }
            }.listStyle(GroupedListStyle())
                .navigationTitle(Text("Update"))
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }, trailing: Button(action: {putScheduleScan()}, label: {Text("Save")}))
        }
    }
    
    func putScheduleScan() {
        guard let url = URL(string: "http://10.212.78.114:8000/scans/\(self.scan.id)")
        else {
            print("The API is down/not connected")
            fatalError("endpoint not active")
            
        }
        
        // Convert selected time to a string
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = timeFormatter.string(from: selectedTime)
        
        // Update scan data
        var scanData = self.scan
        scanData.time = timeString
        
        guard let encoded = try? JSONEncoder().encode(scanData) else {
            print("JSON failed to encode")
            return
        }
        let username = "monishapv"
        let password = "monisha1999"
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(Scan.self, from: data) {
                    DispatchQueue.main.async {
                        //self.patients = response
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    return
                }
            }
            
        }.resume()
    }
}
