//
//  DoctorUpdateView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/11/2022.
//

import SwiftUI

struct DoctorUpdateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var patient: Patient
    
    var fullname: String = ""
    var dob: String = "" 
    var gender: String = ""
    var nhsNo: String = ""
    var address: String = ""
    var medcondition: String = ""
    var patientdescription: String = ""
    var symptoms: String = ""
    var medication: String = ""
    var notes: String = ""
    
    var genders = ["Male", "Female", "Preferred Not To Say"]
    
    
    
    var body: some View {
        NavigationView {
            List{
                Section{
                    TextField("Patient Fullname", text: $patient.fullname)
                    TextField("Date Of Birth (DD/MM/YYYY)", text: $patient.dob)
                    Picker("Gender", selection: $patient.gender) {
                        Text("").tag("") // Add empty tag to avoid selection issues
                        ForEach(genders, id: \.self) {
                            Text($0)
                        }
                    }
                    TextField("NHS Number", text: $patient.nhsNo)
                    TextField("Address", text: $patient.address)
                    TextField("Medical Condition", text: $patient.medcondition)
                    TextField("Condition Description", text: $patient.patientdescription)
                    TextField("Symptoms", text: $patient.symptoms)
                    TextField("Medication", text: $patient.medication)
                    TextField("Doctor Notes", text: $patient.notes)
                }
            }.listStyle(GroupedListStyle())
                .navigationTitle(Text("Update"))
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }, trailing: Button(action: {putPatients()}, label: {Text("Save")}))
        }
    }
    
    func putPatients() {
        guard let url = URL(string: "http://10.212.78.114:8000/patients/\(self.patient.id)") else {
            print("The API is down/not connected")
            fatalError("endpoint not active")
            
        }
        

        let patientData = self.patient
        guard let encoded = try? JSONEncoder().encode(patientData) else {
            print("JSON failed to encode")
            return
        }
        let username = "monishavadivelu"
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
                    JSONDecoder().decode(Patient.self, from: data) {
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


//struct DoctorUpdateView_Previews: PreviewProvider {
//    static var previews: some View {
//        DoctorUpdateView()
//    }
//}
