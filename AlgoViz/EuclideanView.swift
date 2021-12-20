//
//  EuclideanView.swift
//  AlgoViz
//
//  Created by Vlad Gershun on 12/19/21.
//

import SwiftUI

struct EuclideanView: View {
    @State private var algorithm: GCDAlgorithm? = nil
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var temp = 1
    @FocusState private var focus: Focus?
    enum Focus: Hashable {
        case first
        case second
    }
    private var isValid: Bool {
        GCDAlgorithm.isValid(a: firstNumber, b: secondNumber)
    }
    
    @State private var resultValues: [(Int, Int)] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(value: $firstNumber) {
                        TextField("First", value: $firstNumber, format: .number)
                            .numberKeyboard($focus, equals: .first)
                    }
                    
                    Stepper(value: $secondNumber) {
                        TextField("Second", value: $secondNumber, format: .number)
                            .numberKeyboard($focus, equals: .second)
                    }
                  
                    HStack {
                        Button(action: {
                            
                            algorithm = GCDAlgorithm(firstNumber, secondNumber)
                            temp += 1
                            focus = nil
                        }) {
                            Text("Calculate")
                                .frame(maxWidth: .infinity)
                        }
                        .disabled(!isValid)
                        .buttonStyle(.borderless)
                        Divider()
                        Button(action: {
                            firstNumber = Int.random(in: 1...999999)
                            secondNumber = Int.random(in: 1...999999)
                            algorithm = GCDAlgorithm(firstNumber , secondNumber)
                            temp += 1
                            focus = nil
                        }) {
                            Text("Random")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderless)
                    }
                } header: {
                    Text("Enter Numbers")
                }
                
                if let algorithm = algorithm {
                    DisclosureGroup {
                        ForEach(resultValues, id: \.0) { values in
                            DividedNumbersView(left: values.0, right: values.1)
                        }
                    } label: {
                        HStack(spacing: 20) {
                            ZStack {
                                Image(systemName: "chevron.down")
                                Image(systemName: "chevron.right")
                            }.hidden()
                            DividedNumbersView(left: algorithm.larger, right: algorithm.smaller)
                        }
                    }
                    

                    if let result = algorithm.result {
                        Section {
                            HStack{
                                Spacer()
                                Text(result, format: .number)
                                    .transition(.slide)
                                Spacer()
                            }
                        } header: {
                            Text("GCD")
                        }
                        .listRowBackground(Color.green)

                    }
                }
            }
            .navigationTitle("Euclidean Algorithm")
            .background {
                Color.clear
                    .task {
                        guard algorithm != nil else { return }
                        let counter = self.temp
                        var isDone = false
                        while !isDone && !Task.isCancelled {
                            withAnimation {
                                assert(counter == self.temp && !Task.isCancelled)
                                isDone = self.algorithm!.step()
                            }
                            try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                        }
                    }
                    .id("\(firstNumber)\(secondNumber)\(temp)")
            }
            .onChange(of: algorithm) { _ in
                guard let algorithm = algorithm else {
                    return
                }
                if algorithm.result == nil {
                    resultValues.append((algorithm.larger, algorithm.smaller))
                }
                
            }
        }
    }
}

struct DividedNumbersView: View {
    var left: Int
    var right: Int
    var body: some View {
        HStack {
            ZStack {
                Text(left, format: .number)
                Color.clear
            }
            Divider()
            ZStack {
                Color.clear
                Text(right, format: .number)
            }
        }
    }
}

extension View {
    func numberKeyboard<Value: Hashable>(_ focusState: FocusState<Value?>.Binding, equals activeFocusValue: Value) -> some View {
        self.keyboardType(.decimalPad)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                if focusState.wrappedValue == activeFocusValue {
                    Button("Done") {
                        focusState.wrappedValue = nil
                    }
                }
            }
            
        }
        .focused(focusState, equals: activeFocusValue)
    }
}

struct EuclideanView_Previews: PreviewProvider {
    static var previews: some View {
        EuclideanView()
    }
}

