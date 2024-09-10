//
//  SignupView.swift
//  WeSplit
//
//  Created by Joannaye on 2024/9/9.
//

import SwiftUI

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSignedUp: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showSuccessfulMessage = false

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding(.bottom, 40)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button(action: {
                if !Validation.emailValidation(email) {
                    alertMessage = "Invalid email format."
                    showAlert = true
                } else if !Validation.passwordValidation(password) {
                    alertMessage = "Password must be at least 8 characters long, contain an uppercase letter, a number, and a special character."
                    showAlert = true
                } else if password != confirmPassword || email.isEmpty {
                    alertMessage = "Passwords do not match or fields are empty."
                    showAlert = true
                } else {
                    signUp(email: email, password: password)
                }
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sign-Up Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            if showSuccessfulMessage {
                Text("Sign up successful!")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding(.top, 20)
            }
        }
        .padding()
    }

    // Function to send signup request to the backend
    func signUp(email: String, password: String) {
        guard let url = URL(string: "http://128.61.41.164:5001/api/signup") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Failed to sign up: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                DispatchQueue.main.async {
                    alertMessage = "Sign-up failed. User may already exist."
                    showAlert = true
                }
                return
            }

            // Navigate to login view after successful signup
            DispatchQueue.main.async {
                isSignedUp = true
                showSuccessfulMessage = true
            }
        }.resume()
    }
}

#Preview {
    SignupView()
}
