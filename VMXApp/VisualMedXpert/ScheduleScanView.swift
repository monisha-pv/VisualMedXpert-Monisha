//
//  ScheduleScanView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/02/2023.
//

import SwiftUI

struct ScheduleScanView: View {
    @State var scans = [Scan]()
    @State var showAdd = false

    
    var body: some View {
        NavigationView {
            List {
                ForEach(scans) { scan in
                    HStack {
                        NavigationLink (
                            destination: ScheduleScanDetailView(scan: scan)) {
                            Image(systemName: "heart.text.square.fill").foregroundColor(.blue)
                            Text(scan.name)
                            Spacer()
                            Text(scan.date)
                            Spacer()
                            Text("\(scan.time)")

                        }
                    }
                }
                   
            }.onAppear(perform: getScheduleScan)
                .navigationBarTitle("Your Bookings")
                .navigationBarItems(trailing: Button(action: {showAdd.toggle()}, label: {
                    Image(systemName: "plus.circle")
                }))
                .listStyle(PlainListStyle())
                .sheet(isPresented: $showAdd, content: {
                    ScanAddView(function: self.getScheduleScan)
            })
        }
    }
    

    
    func getScheduleScan() {
        guard let url = URL(string: "http://10.212.78.114:8000/scans/") else {
            print("The API is down/not connected")
            return
            
            
        }
        
        // Authenticate API
        let username = "monishapv"
        let password = "monisha1999"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response,
            error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode([Scan].self, from: data) {
                    DispatchQueue.main.async {
                        self.scans = response
                    }
                    
                }
            }
            
        }.resume()
    }
}

struct ScanAddView : View {
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    
    var function: () -> Void
    
    @State var name: String = ""
    @State var gender: String = ""
    @State var condition: String = ""
    @State var scanType: String = ""
    @State var centre: String = ""
    @State var date: String = ""
    @State var time: String = ""
    
    var genders = ["Male", "Female", "Prefer to not say"]
    var scantypes = ["X-ray", "CT Scan", "MRI Scan", "Electrocardiogram (ECG)", "PET scan", "Angiography", "Ultrasound scan", "Echocardiogram"]
    var centres = ["Derriford Hospital", "Nuffield Health Plymouth Hospital"]
    var availabletimes = ["13:00", "14:30", "16:00", "16:45", "17:00"]
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Full name", text: $name)
                    Picker("Gender", selection: $gender) {
                        Text("").tag("") // Add empty tag to avoid selection issues
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Condition", text: $condition)
                    Picker("Type of Scan", selection: $scanType) {
                        Text("").tag("")
                        ForEach(scantypes, id:\.self) {
                            Text($0)
                        }
                    }
                    Picker("Centre", selection: $centre) {
                        Text("").tag("")
                        ForEach(centres, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("Date (DD/MM/YYYY)", text: $date)
                    Picker("Time", selection: $time) {
                        Text("").tag("")
                        ForEach(availabletimes, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Book Scan")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
                trailing: Button(action: {postScheduleScan()}, label: {
                Text("Book")
            }))
        }
    }

    
    func postScheduleScan() {
        guard let url = URL(string: "http://10.212.78.114:8000/scans/") else {
            print("The API is down/not connected")
            return
        }
        
        let scanData = Scan(id: 0, name: self.name, gender: self.gender, condition: self.condition, scanType: self.scanType,
                                  centre: self.centre, date: self.date, time: self.time)
        
        guard let encoded = try? JSONEncoder().encode(scanData) else {
            print("JSON failed to encode")
            return
        }
        
        let username = "monishapv"
        let password = "monisha1999"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        request.httpBody = encoded
        
        
        URLSession.shared.dataTask(with: request) { data, response,
            error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(Scan.self, from: data) {
                    DispatchQueue.main.async {
                        //self.patients = response
                        self.function()
                        presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
            }
            
        }.resume()
    }
}


struct ScheduleScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleScanView()
    }
}

