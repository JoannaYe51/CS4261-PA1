//
//  ContentView.swift
//  WeSplit
//
//  Created by Joannaye on 2022/10/30.
//

import SwiftUI
//main UI for the progrms

struct ContentView: View {  //different views
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @State private var note = ""
    @FocusState private var amountIsFocused: Bool
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        return (checkAmount + checkAmount * (Double(tipPercentage) / 100)) / peopleCount
    }
    
    var totalAmount: Double {
        return (checkAmount + checkAmount * (Double(tipPercentage) / 100))
    }
    
    struct totalAmountTitle: ViewModifier {
        var tips: Int
        
        func body(content: Content) -> some View {
            if tips == 0 {
                content.foregroundColor(Color.orange)
            } else {
                content.foregroundColor(.primary)
            }
        }
    }
    
    var body: some View {   //layout
        NavigationView {    //give some space for ios add views (for picker)
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                            
                    Picker("Party Size", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0)")
                        }
                    }
                    
                    TextField("Note", text: $note)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5.0)
                }
                
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0..<101) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("How much tips do you want to leave?")
                }
                
                Section {
                    Text(totalAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total amount:").modifier(totalAmountTitle(tips: tipPercentage))
                }
                
                Section {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .font(.title2)
                        .foregroundColor(.blue)
                } header: {
                    Text("Total amount per person: ")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFocused = false
                        saveToHistory()
                    }
                }
            }
        }
    }
    
    func saveToHistory() {
        let total = totalPerPerson
        let note = self.note
        
        let history = [
            "amount": total,
            "note": note,
            "date": Date().timeIntervalSince1970
        ] as [String : Any]
        
        guard let url = URL(string: "http://128.61.41.164:5001/api/history") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: history)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Failed to save: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Failed to save: Invalid response")
                return
            }
            
            //just adding more error handler to make sure
            if httpResponse.statusCode != 201 {
                // Localization error
                if let localizedData = data, let errorMessage = String(data: localizedData, encoding: .utf8) {
                    print("Failed to save: \(errorMessage)")
                } else {
                    print("Failed to save: Invalid status code \(httpResponse.statusCode)")
                }
                return
            }

            print("Saved successfully!")
        }.resume()
    }
}

//just for debugging, ...
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
