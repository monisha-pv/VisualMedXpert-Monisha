//
//  RegistrationView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 25/03/2023.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isDisabled = true
    @State private var showErrorAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessAlert = false
    @State private var selectedRole = "patient"

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
                        .accessibilityIdentifier("Email")
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
                        .accessibilityIdentifier("Password")
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: password) { _ in
                            enableButton()
                        }
                }

                HStack {
                    Text("Confirm Password:")
                    Spacer()
                    SecureField("", text: $confirmPassword)
                        .accessibilityIdentifier("ConfirmPassword")
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: confirmPassword) { _ in
                            enableButton()

                        }
                }

                Picker("Role", selection: $selectedRole) {
                    Text("Patient").tag("patient")
                    Text("Doctor").tag("doctor")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

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
        let passwordsMatch = password == confirmPassword
        isDisabled = !(emailIsValid && passwordIsValid && passwordsMatch)
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
        
        guard password == confirmPassword else {
            showAlert(title: "Something went wrong", message: "Passwords do not match.")
            return
        }
        
        let role: String
        
        if email.hasSuffix("@vmxdoctor.com") {
            role = "doctor"
        } else {
            role = "patient"
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert(title: "Something went wrong", message: error.localizedDescription)
            } else {
                let uid = result?.user.uid ?? ""
                let data: [String: Any] = ["email": email, "role": role]
                Firestore.firestore().collection("users").document(uid).setData(data) { error in
                    if let error = error {
                        showAlert(title: "Something went wrong", message: error.localizedDescription)
                    } else {
                        email = ""
                        password = ""
                        confirmPassword = ""
                        DispatchQueue.main.async {
                            showSuccessAlert = true
                        }
                    }
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

