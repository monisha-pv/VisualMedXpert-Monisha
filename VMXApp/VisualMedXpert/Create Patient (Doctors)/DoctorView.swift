//
//  DoctorView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI

struct DoctorView: View {
    @State var patients = [Patient]()
    @State var showAdd = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(patients) { patient in
                    HStack {
                        NavigationLink (
                            destination: DoctorDetailView(patient: patient)) {
                            Image(systemName: "person.fill").foregroundColor(.blue)
                            Text(patient.fullname)
                            Spacer()
                            Text(patient.dob)

                        }
                    }
                }
                   
            }.onAppear(perform: getPatients)
                .navigationBarTitle("Patient Details")
                .navigationBarItems(trailing: Button(action: {showAdd.toggle()}, label: {
                    Image(systemName: "plus.circle")
                }))
                .listStyle(PlainListStyle())
                .sheet(isPresented: $showAdd, content: {
                    PatientAddView(function: self.getPatients)
            })
        }
    }
    

    
    func getPatients() {
        guard let url = URL(string: "http://10.212.78.114:8000/patients/") else {
            print("The API is down/not connected")
            return
            
            
        }
        
        // Authenticate Firebase
        let username = "monishavadivelu"
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
                    JSONDecoder().decode([Patient].self, from: data) {
                    DispatchQueue.main.async {
                        self.patients = response
                    }
                }
            }
            
        }.resume()
    }
}

struct PatientAddView : View {
    @Environment(\.presentationMode) var presentationMode
    var function: () -> Void
    
    @State var fullname: String = ""
    @State var dob: String = ""
    @State var gender: String = ""
    @State var nhsNo: String = ""
    @State var address: String = ""
    @State var medcondition: String = ""
    @State var patientdescription: String = ""
    @State var symptoms: String = ""
    @State var medication: String = ""
    @State var notes: String = ""
    
    var genders = ["Male", "Female", "Preferred Not To Say"]
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    TextField("Full name", text: $fullname)
                    TextField("Date Of Birth (DD/MM/YYYY)", text: $dob)
                    Picker("Gender", selection: $gender) {
                        Text("").tag("") // Add empty tag to avoid selection issues
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("NHS Number", text: $nhsNo)
                    TextField("Address", text: $address)
                    TextField("Medical Condition", text: $medcondition)
                    TextField("Condition Description", text: $patientdescription)
                    TextField("Symptoms", text: $symptoms)
                    TextField("Medication", text: $medication)
                    TextField("Doctor Notes", text: $notes)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Add Patient")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            },
            trailing: Button(action: {postPatients()}, label: {
                Text("Save")
            }))
                
        }
    }
    
    func postPatients() {
        guard let url = URL(string: "http://10.212.78.114:8000/patients/") else {
            print("The API is down/not connected")
            return
        }
        
        let patientData = Patient(id: 0, fullname: self.fullname, dob: self.dob, gender: self.gender, nhsNo: self.nhsNo, address: self.address, medcondition: self.medcondition,
                                  patientdescription: self.patientdescription, symptoms: self.symptoms, medication: self.medication, notes: self.notes)
        
        guard let encoded = try? JSONEncoder().encode(patientData) else {
            print("JSON failed to encode")
            return
        }
        print(String(data: encoded, encoding: .utf8) ?? "Failed to convert encoded data to string")
        
        let username = "monishavadivelu"
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
                    JSONDecoder().decode(Patient.self, from: data) {
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


struct DoctorView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorView()
    }
}
