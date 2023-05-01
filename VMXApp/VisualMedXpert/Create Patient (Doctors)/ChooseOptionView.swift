//
//  ChooseOptionView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI
import Firebase

struct ChooseOptionView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: DoctorView()) {
                    Text("Manage Patient Records")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Spacer().frame(height: 50)
                NavigationLink(destination: ContentView()) {
                    Text("Augumented Reality (Medical Learning)")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Spacer().frame(height: 50)
                NavigationLink(destination: DirectImageClassification()) {
                    Text("Image Classification (AI)")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Spacer().frame(height: 50)
                NavigationLink(destination: ViewPatientBookings()) {
                    Text("Patient Booking Requests")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
            .navigationBarTitle("Choose An Option", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("Doctor log out successful!")
                            dismiss()
                        } catch {
                            print("ERROR: Doctor could not sign out!")
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}




struct ChooseOptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChooseOptionView()
        }
    }
}
