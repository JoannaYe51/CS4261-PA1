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
                content.foregroundColor(Color.red)
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
                    }
                }
            }
        }
    }
}

//just for debugging, ...
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
