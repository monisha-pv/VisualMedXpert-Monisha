//
//  LoginView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 12/11/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonsDisabled = true
    @State private var path = NavigationPath()
    @FocusState private var focusField: Field?
    
    
    var body: some View {
        NavigationStack (path: $path) {
            Image("VMXIcon")
                .resizable()
                .scaledToFit()
                .padding()
            
            Group {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButtons()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil //dismiss the keyboard
                    }
                    .onChange(of: password) { _ in
                        enableButtons()
                    }
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack {
                Button {
                    register()
                    
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                
                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonsDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color(.black))
            .font(.title2)
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { view in
                if view == "ChooseOptionView" {
                    ChooseOptionView()
                }
            }
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }

        .onAppear {
            // if logged in navigate to the new screen and skip login screen
            if Auth.auth().currentUser != nil {
                print("Login success")
                path.append("ChooseOptionView")
            }
        }
    }
    
    func enableButtons() {
        let emailOK = email.count > 6 && email.contains("@")
        let passwordOK = password.count > 6
        buttonsDisabled = !(emailOK && passwordOK)
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error
            in
            if let error = error {
                print("SIGNIN ERROR: \(error.localizedDescription)")
                alertMessage = "SIGNIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Registration success")
                path.append("ChooseOptionView")
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error
            in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Login success")
                path.append("ChooseOptionView")
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}