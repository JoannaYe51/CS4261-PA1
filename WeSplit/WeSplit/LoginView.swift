//
//  LoginView.swift
//  WeSplit
//
//  Created by Joannaye on 2024/9/9.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var token: String? = nil  // To store JWT token

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                
                Button(action: {
                    login(email: email, password: password)
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                HStack {
                    Text("Don't have an account?").foregroundStyle(.gray)
                    NavigationLink("Sign Up", destination: SignupView())
                }
                .padding(.top, 20)
                
            }
            .padding()
            .fullScreenCover(isPresented: $isLoggedIn) {
                ContentView()  // Navigate to content after login
            }
        }
    }

    // Function to send login request to the backend
    func login(email: String, password: String) {
        guard let url = URL(string: "http://128.61.41.164:5001/api/login") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Failed to login: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let token = json["token"] as? String else {
                DispatchQueue.main.async {
                    alertMessage = "Invalid username or password"
                    showAlert = true
                }
                return
            }

            // Store the JWT token and log the user in
            DispatchQueue.main.async {
                self.token = token
                self.isLoggedIn = true
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
