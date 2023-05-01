//
//  PatientLoginView.swift
//  VisualMedXpert
//
//  Created by Monisha Vadivelu on 16/03/2023.
//

import SwiftUI
import Firebase

struct PatientLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isDisabled = true
    @StateObject private var userAuth = UserAuth()
    @State private var showUserDetail = false
    
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
                
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if let user = result?.user {
                            let name = user.email?.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: " ")
                            let userModel = User(uid: user.uid, email: user.email, displayName: name)
                            userAuth.userModel = userModel
                            showUserDetail = true
                        }
                    }
                }) {
                    
                NavigationLink(
                    destination: UserDetailView(userModel: userAuth.userModel ?? User(uid: nil, email: nil, displayName: nil))
                        .environmentObject(userAuth),
                    isActive: $showUserDetail
                ) {
                    EmptyView()
                }
                .hidden()
                    
                    Text("Log In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(5.0)
                    }
                    .padding(.horizontal)

                    Spacer()

                    NavigationLink(destination: RegistrationView().navigationBarBackButtonHidden(true)) {
                        Text("Don't have an account? Register")
                    }
                    .padding(.horizontal)
                
            }
            .navigationBarTitle("Patient Login")
            .navigationBarHidden(true)
        }
    }
    
    private func enableButton() {
        let emailIsValid = email.isValidEmailLogin
        let passwordIsValid = password.count >= 6
        isDisabled = !(emailIsValid && passwordIsValid)
    }
}


struct UserDetailView: View {
    var userModel: User
    @EnvironmentObject var userAuth: UserAuth
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            if let displayName = userModel.displayName {
                Text("Welcome to VisualMedXpert, \(displayName)!")
                    .font(.headline)
                    .padding(.bottom, 20)
            }

            if let displayName = userModel.displayName {
                Text("Name: \(displayName)")
            }

            if let email = userModel.email {
                Text("Email: \(email)")
            }
            
            Spacer().frame(height: 40)
            Text("Please choose an option below to continue.")
                .font(.subheadline)
                .padding(.bottom, 30)
            
            Spacer().frame(height: 90)
            NavigationLink(destination: ScheduleScanView().navigationBarBackButtonHidden(false)) {
                Text("Book a scan appointment")
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            
            Spacer().frame(height: 40)
            NavigationLink(destination: SwiftUI_Chatbot().navigationBarBackButtonHidden(false)) {
                Text("VMX ChatBot")
                    .padding()
                    .background(.black)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    do {
                        try Auth.auth().signOut()
                        userAuth.userModel = nil
                        presentationMode.wrappedValue.dismiss()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                }) {
                    Text("Sign Out")
                }
            }
        }
    }
}






class UserAuth: ObservableObject {
    @Published var userModel: User?
}

struct PatientDetailView: View {
    @StateObject private var userAuth = UserAuth()

    var body: some View {
        NavigationView {
            VStack {
                PatientLoginView()
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { (auth, user) in
                            if let user = user {
                                let name = user.email?.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: " ")
                                let userModel = User(uid: user.uid, email: user.email, displayName: name)
                                userAuth.userModel = userModel
                            }
                        }
                    }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        }
        .environmentObject(userAuth)
    }
}



struct PatientLoginView_Previews: PreviewProvider {
    static var previews: some View {
        PatientDetailView()
    }
}






















