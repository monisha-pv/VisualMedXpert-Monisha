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
    @State private var showDialog = false
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                Text("Welcome to VisualMedXpert")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text("Please choose an option below to continue.")
                    .font(.subheadline)
                    .padding(.bottom, 30)
                
                VStack {
                    NavigationLink(destination: DoctorView()) {
                        Text("Manage Patient Records")
                            .padding()
                            .background(.black)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    
                    Spacer().frame(height: 50)
                    
                    NavigationLink(destination: ContentView()) {
                        Text("Augmented Reality (Medical Learning)")
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
                
                Spacer()
                
                Button(action: {
                    showDialog = true
                }) {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
                .sheet(isPresented: $showDialog, content: {
                    AboutView(displayDialog: $showDialog)
                })
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

struct AboutView: View {
    @Binding var displayDialog: Bool
    
    var body: some View {
        VStack {
            Text("About VMX")
                .font(.title)
                .padding(.bottom, 10)
            
            Text("Option 1: Manage patient records. View, create, update, and delete patient records.")
                .padding(.bottom, 5)
            Text("Option 2: Augmented Reality (Medical Learning). We offer a variety of 3D anatomical models that can be displayed on your camera for interactive learning. Use two fingers to scale, translate, and rotate the models.")
                .padding(.bottom, 5)
            Text("Option 3: Image Classification (AI). This option directs you to two image classifiers, allowing you to choose the one that best suits your needs.")
                .padding(.bottom, 5)
            Text("Option 4: Patient Booking Requests. View all booking requests submitted by your patients, and update or cancel their bookings if necessary.")
                .padding(.bottom, 5)
            
            Spacer()
            
            Button("Close") {
                displayDialog = false
            }
        }
        .padding()
    }
}

struct ChooseOptionView_Previews: PreviewProvider {
    static var previews: some View {
       ChooseOptionView()
    }
}


