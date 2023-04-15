//
//  ViewPatientBookings.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 01/04/2023.
//

import SwiftUI


struct ViewPatientBookings: View {
    @State var scans = [Scan]()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(scans) { scan in
                    HStack {
                        NavigationLink (
                            destination: PatientBookingDetailView(scan: scan)) {
                            Image(systemName: "person.fill").foregroundColor(.blue)
                            Text(scan.name)
                            Spacer()
                            Text(scan.date)
                        }
                    }
                }
                   
            }.onAppear(perform: getPatientBooking)
                .navigationBarTitle("Patient Bookings")
                .listStyle(PlainListStyle())
        }
    }
    

    
    func getPatientBooking() {
        guard let url = URL(string: "http://10.212.78.114:8000/scans/") else {
            print("The API is down/not connected")
            return
            
            
        }
        
        // Authenticate Firebase
        let username = "monishapv"
        let password = "monisha1999"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let authData = (username + ":" + password).data(using: .utf8)!.base64EncodedString()
        request.addValue("Basic \(authData)", forHTTPHeaderField: "Authorization")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode([Scan].self, from: data) {
                    DispatchQueue.main.async {
                        self.scans = response
                    }
                }
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }.resume()
    }
}


struct ViewPatientBookings_Previews: PreviewProvider {
    static var previews: some View {
        ViewPatientBookings()
    }
}
