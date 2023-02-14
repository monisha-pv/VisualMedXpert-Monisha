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
     var gender: String = ""
     var condition: String = ""
     var scanType: String = ""
     var centre: String = ""
     var date: String = ""
     var time: String = ""


    
    var body: some View {
        NavigationView {
            List{
                Section{
                    TextField("Full name", text: $scan.name)
                    TextField("Gender", text: $scan.gender)
                    TextField("Condition", text: $scan.condition)
                    TextField("Type of Scan", text: $scan.scanType)
                    TextField("Centre", text: $scan.centre)
                    TextField("Date", text: $scan.date)
                    TextField("Time", text: $scan.time)
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
        
//        let scanData = ScanElement(id: 0, name: self.name, gender: self.gender, condition: self.condition, scanType: self.scanType,
//                                  centre: self.centre, date: self.date, time: self.time)
        let scanData = self.scan
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
