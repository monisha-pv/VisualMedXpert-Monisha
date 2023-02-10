//
//  PatientView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI
import Firebase

struct PatientView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: PatientChatBot()) {
                    Text("VMX ChatBot")
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
                        print("Patient log out successful!")
                        dismiss()
                    } catch {
                        print("ERROR: Patient could not sign out!")
                    }
                }
            }
        }
    }
}

struct PatientView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PatientView()
        }
    }
}
