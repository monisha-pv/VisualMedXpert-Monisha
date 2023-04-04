//
//  RegistrationView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 25/03/2023.
//

import SwiftUI
import Firebase

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isDisabled = true
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
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
                    
                    Button(action: register) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(5.0)
                    }
                    .padding(.horizontal)
                    .disabled(isDisabled)
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                        Text("Already have an account? Login")
                    }
                }
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Something went wrong"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showSuccessAlert) {
                    Alert(title: Text("Success"), message: Text("You have successfully registered to VMX."), dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                .navigationBarTitle("Register")
                .navigationBarBackButtonHidden(true)
            }
        }
        
        private func enableButton() {
            let emailIsValid = email.isValidEmail
            let passwordIsValid = password.count >= 6
            isDisabled = !(emailIsValid && passwordIsValid)
        }
        
        private func register() {
            guard email.isValidEmail else {
                showAlert(title: "Something went wrong", message: "Please enter a valid email address.")
                return
            }
            
            guard password.count >= 6 else {
                showAlert(title: "Something went wrong", message: "Please enter a password that is at least 6 characters long.")
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if let error = error {
                        showAlert(title: "Something went wrong", message: error.localizedDescription)
                    } else {
                        email = ""
                        password = ""
                        DispatchQueue.main.async {
                            showSuccessAlert = true
                        }
                    }
              }
        }
        
        private func showAlert(title: String, message: String) {
            alertMessage = message
            showErrorAlert = true
        }
    }


extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

