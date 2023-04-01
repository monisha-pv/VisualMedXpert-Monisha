//
//  DoctorDetailView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 13/11/2022.
//

import SwiftUI

struct DoctorDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var patient: Patient
    @State var showEdit = false
    
    var body: some View {
        List {
            HStack {
                Text("Patient Details")
                Spacer()
                
            }
            Section {
                Text("FullName: \(patient.fullname)")
                Text("Date Of Birth: \(patient.dob)")
                Text("Address: \(patient.address)")
                Text("Condition: \(patient.medcondition)")
                Text("Description: \(patient.patientdescription)")
                Text("Symptoms: \(patient.symptoms)")
                Text("Medication: \(patient.medication)")
                Text("Notes: \(patient.notes)")
          
            }
            
            Section {
                Button(action: {self.deletePatients()}, label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                })
            }
        }.listStyle(GroupedListStyle())
            .navigationTitle(patient.fullname)
            .navigationBarItems(trailing: Button(action: {self.showEdit.toggle()}, label: {
                Text("Edit")
                    .sheet(isPresented: $showEdit, content: {
                        DoctorUpdateView(patient: $patient)
                    })
            }))
    }
    
    func deletePatients() {
        guard let url = URL(string: "http://10.212.78.114:8000/patients/\(self.patient.id)") else {
            print("The API is down/not connected")
            return
            
        }
        
        let username = "monishavadivelu"
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

struct DoctorDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorDetailView(patient: Patient(id: 0, fullname: "Monisha V", dob: "31/12/1999", address: "123 ETON ROAD", medcondition: "Cancer", patientdescription: "test patient description", symptoms: "test symptoms", medication: "test medication", notes: "test notes"))
    }
}
