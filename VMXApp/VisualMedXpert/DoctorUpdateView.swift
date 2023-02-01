//
//  DoctorUpdateView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/11/2022.
//

import SwiftUI

struct DoctorUpdateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var patient: PatientElement
    
    @State var fullname: String = ""
    @State var dob: String = ""
    @State var address: String = ""
    @State var medcondition: String = ""
    @State var patientdescription: String = ""
    @State var symptoms: String = ""
    @State var medication: String = ""
    @State var notes: String = ""
    
    
    
    var body: some View {
        NavigationView {
            List{
                Section{
                    TextField("Patient Fullname", text: $fullname)
                    TextField("Date Of Birth (DD/MM/YYYY)", text: $dob)
                    TextField("Address", text: $address)
                    TextField("Medical Condition", text: $medcondition)
                    TextField("Condition Description", text: $patientdescription)
                    TextField("Symptoms", text: $symptoms)
                    TextField("Medication", text: $medication)
                    TextField("Doctor Notes", text: $notes)
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
        
        let patientData = PatientElement(id: 0, fullname: self.fullname, dob: self.dob, address: self.address, medcondition: self.medcondition,
                                  patientdescription: self.patientdescription, symptoms: self.symptoms, medication: self.medication, notes: self.notes)
        
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
                    JSONDecoder().decode(PatientElement.self, from: data) {
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
