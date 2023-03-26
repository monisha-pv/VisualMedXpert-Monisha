//
//  ScheduleScanDetailView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/02/2023.
//

import SwiftUI

struct ScheduleScanDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var scan: Scan
    @State var showEdit = false
    
    var body: some View {
        List {
            HStack {
                Text("Scan Reference Details")
                Spacer()
                
            }
            Section {
                Text("Full name: \(scan.name)")
                Text("Gender: \(scan.gender)")
                Text("Condition: \(scan.condition)")
                Text("Type of Scan: \(scan.scanType)")
                Text("Centre: \(scan.centre)")
                Text("Date: \(scan.date)")
                Text("Time: \(scan.time)")
          
            }
            
            Section {
                Button(action: {self.deleteScheduleScan()}, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Cancel")
                    }
                })
            }
        }.listStyle(GroupedListStyle())
            .navigationTitle(scan.name)
            .navigationBarItems(trailing: Button(action: {self.showEdit.toggle()}, label: {
                Text("Amend")
                    .sheet(isPresented: $showEdit, content: {
                        ScheduleScanUpdateView(scan: $scan)
                    })
            }))
    }
    
    func deleteScheduleScan() {
        guard let url = URL(string: "http://10.212.78.114:8000/scans/\(self.scan.id)") else {
            print("The API is down/not connected")
            return
            
        }
        
        let username = "monishapv"
        let password = "monisha1999"
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                
                DispatchQueue.main.async {
                    print("\(data)")
                    self.presentationMode.wrappedValue.dismiss()
                    
                }
                return
               
            }
            
        }.resume()
    }
}

struct ScheduleScanDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleScanDetailView(scan: Scan(id: 0, name: "Monisha V", email: "monishapv@hotmail.com", gender: "Female", condition: "Lung Cancer", scanType: "CT Scan", centre: "Derriford Hospital", date: "20/02/2023", time: "13:45"))
    }
}
