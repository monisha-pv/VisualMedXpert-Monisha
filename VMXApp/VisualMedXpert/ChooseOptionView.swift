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
                    Text("I am a Doctor...")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                Spacer().frame(height: 50)
                NavigationLink(destination: PatientView()) {
                    Text("I am a Patient...")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                
                Spacer().frame(height: 50)
                NavigationLink(destination: ContentView()) {
                    Text("AR View")
                        .padding()
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
            }
        }

        .navigationBarTitle("Choose An Option")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("Log out successful!")
                        dismiss()
                    } catch {
                        print("ERROR: Could not sign out!")
                    }
                }
            }
        }
    }
}



struct ChooseOptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChooseOptionView()
        }
    }
}
