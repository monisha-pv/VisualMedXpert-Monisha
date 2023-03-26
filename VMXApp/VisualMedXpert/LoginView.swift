//
//  LoginView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isDisabled = true
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Image("VMXIcon")
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                HStack {
                    Text("  Email:")
                    Spacer()
                    TextField("", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: email) { _ in
                            enableButton()
                        }
                }
                
                HStack {
                    Text("  Password:")
                    Spacer()
                    SecureField("", text: $password)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: password) { _ in
                            enableButton()
                        }
                }
                
                Button(action: login) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(5.0)
                }
                .padding(.horizontal)
                .disabled(isDisabled)
                
                NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true).navigationBarHidden(true)) {
                    Text("Don't have an account? Register")
                }
                
                Spacer()
                
                NavigationLink(destination: PatientLoginView().navigationBarBackButtonHidden(true).navigationBarHidden(true)) {
                    Text("Patient Login")
                }
            }
            .navigationBarTitle("Doctor Login")
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    private func enableButton() {
        let emailIsValid = email.isValidEmailLogin
        let passwordIsValid = password.count >= 6
        isDisabled = !(emailIsValid && passwordIsValid)
    }
    
    private func login() {
        guard email.isValidEmailLogin else {
            return
        }
        
        guard password.count >= 6 else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                email = ""
                password = ""
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

extension String {
    var isValidEmailLogin: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


