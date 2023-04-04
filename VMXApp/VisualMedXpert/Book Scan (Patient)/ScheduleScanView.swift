//
//  ScheduleScanView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/02/2023.
//

import SwiftUI
import Firebase

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
        
        // using users email fetch and display their booking 
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Scan].self, from: data) {
                    if let email = Auth.auth().currentUser?.email {
                        let showPatientDetails = response.filter { $0.email == email }
                        DispatchQueue.main.async {
                            self.scans = showPatientDetails
                        }
                    }
                }
            }
        }.resume()
    }
}


struct ScanAddView : View {
    @Environment(\.presentationMode) var presentationMode
    @State var showAlert : Bool = false
    @State private var enableNotificaition = false
    
    var function: () -> Void
    
    @State var name: String = ""
    @State var email: String = ""
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
                    TextField("Email", text: $email)
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
                Toggle("Notify Me", isOn: $enableNotificaition)
                    .onChange(of: enableNotificaition) { value in
                        notifyPatient()
                        print("Notification is sending")
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
        
        let scanData = Scan(id: 0, name: self.name, email: self.email, gender: self.gender, condition: self.condition, scanType: self.scanType,
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
        
        // logged-in user's email
        if let email = Auth.auth().currentUser?.email {
            let jsonData = try! JSONSerialization.jsonObject(with: encoded, options: []) as! [String: Any]
            let jsonWithUserEmail = jsonData.merging(["email": email], uniquingKeysWith: { (current, _) in current })
            let encodedWithUserEmail = try! JSONSerialization.data(withJSONObject: jsonWithUserEmail, options: [])
            request.httpBody = encodedWithUserEmail
            let jsonString = String(data: encodedWithUserEmail, encoding: .utf8)!
            print("JSON data with user email: \(jsonString)")
        } else {
            print("No user is logged in")
            return
        }

        
        
        URLSession.shared.dataTask(with: request) { data, response,
            error in
            if let data = data {
                if let response = try?
                    JSONDecoder().decode(Scan.self, from: data) {
                    DispatchQueue.main.async {
                        self.function()
                        presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
            }
            
        }.resume()
    }
}

func notifyPatient() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
        success, error in
        if success {
            print("All set!")
        } else if let error = error {
            print(error.localizedDescription)
            
        }
    }
    let content = UNMutableNotificationContent()
    content.title = "VisualMedXpert"
    content.subtitle = "Thank you, your scan has been scheduled!"
    content.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}



struct ScheduleScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleScanView()
    }
}
