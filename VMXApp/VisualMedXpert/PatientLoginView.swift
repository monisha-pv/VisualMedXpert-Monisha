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
    @StateObject private var userAuth = UserAuth()
    @State private var showUserDetail = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Email:")
                        .font(.headline)
                        .layoutPriority(1)
                    TextField("", text: $email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .cornerRadius(5.0)
                        .padding(.trailing, 20)
                        .frame(height: 40)
                }
                .padding(.bottom, 20)

                HStack {
                    Text("Password:")
                        .font(.headline)
                        .layoutPriority(1)
                    SecureField("", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .cornerRadius(5.0)
                        .padding(.trailing, 20)
                        .frame(height: 40)
                }
                .padding(.bottom, 20)

                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if let user = result?.user {
                            let name = user.email?.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: " ")
                            let userModel = UserModel(uid: user.uid, email: user.email, displayName: name)
                            userAuth.userModel = userModel
                            showUserDetail = true
                        }
                    }
                }) {
                    Text("Log in")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(5.0)
                }
                .padding(.horizontal)

                NavigationLink(
                    destination: UserDetailView(userModel: userAuth.userModel ?? UserModel(uid: nil, email: nil, displayName: nil)),
                    isActive: $showUserDetail
                ) {
                    EmptyView()
                }
                .hidden()

            }
            .navigationBarTitle("Patient Login")
        }
    }
}

struct UserDetailView: View {
    var userModel: UserModel

    var body: some View {
        VStack {
            if let displayName = userModel.displayName {
                Text("Welcome, \(displayName)!")
                    .font(.headline)
                    .padding(.bottom, 20)
            }
//            if let uid = userModel.uid {
//                Text("User ID: \(uid)")
//            }

            if let displayName = userModel.displayName {
                Text("Name: \(displayName)")
            }

            if let email = userModel.email {
                Text("Email: \(email)")
            }
            Spacer()
        }
    }
}

class UserAuth: ObservableObject {
    @Published var userModel: UserModel?
}

struct NewView: View {
    @StateObject private var userAuth = UserAuth()

    var body: some View {
        NavigationView {
            VStack {
                PatientLoginView()
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { (auth, user) in
                            if let user = user {
                                let name = user.email?.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: " ")
                                let userModel = UserModel(uid: user.uid, email: user.email, displayName: name)
                                userAuth.userModel = userModel
                            }
                        }
                    }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct PatientLoginView_Previews: PreviewProvider {
    static var previews: some View {
        NewView()
    }
}






















