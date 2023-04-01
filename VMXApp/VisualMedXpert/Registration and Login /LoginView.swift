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
    @State private var isAuthenticated = false // track if user is authenticated
    @State private var showAlert = false // track if alert should be shown
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
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
                
                NavigationLink(destination: RegistrationView()) {
                    Text("Don't have an account? Register")
                }
                .padding(.bottom)
                                
                NavigationLink(destination: PatientLoginView().navigationBarBackButtonHidden(true)) {
                    Text("Are you a patient? Login")
                }
                
                .background(
                    NavigationLink(destination: ChooseOptionView(), isActive: $isAuthenticated) {
                        EmptyView()
                    }
                    .hidden()
                
            )}
            .navigationBarTitle("Doctor Login")
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })
        }
    }
    
    private func enableButton() {
        let emailIsValid = email.isValidEmailLogin
        let passwordIsValid = password.count >= 6
        isDisabled = !(emailIsValid && passwordIsValid)
    }
    
    private func login() {
        guard email.isValidEmailLogin else {
            showAlert(title: "Invalid email", message: "Please enter a valid email address.")
            return
        }
        
        guard password.count >= 6 else {
            showAlert(title: "Invalid password", message: "Password must be at least 6 characters long.")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert(title: "Error", message: error.localizedDescription)
            } else {
                if let user = result?.user, let firebaseEmail = user.email {
                    if firebaseEmail.contains("@vmxdoctor.com") {
                        email = firebaseEmail
                        password = ""
                        isAuthenticated = true // set to true after successful login
                        // Navigate to ChooseOptionView
                        NavigationLink(destination: ChooseOptionView()) {
                                    EmptyView()
                        }.hidden()
                    } else {
                        showAlert(title: "Invalid email", message: "You must use a VMXDoctor email to log in.")
                    }
                } else {
                    showAlert(title: "Error", message: "Invalid email or password.")
                }
            }
        }
    }



    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
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





